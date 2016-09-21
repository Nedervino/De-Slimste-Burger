import React, { Component } from 'react';
import 'whatwg-fetch';
import './App.css';
import logo from './logo.png';

const API_ROOT = '//api.deslimsteburger.argu.co:3000/';
const DELAY = 2000;

const apiCall = (url, method, body) => {
  const headers = method === 'POST' ? {
    'Accept': 'application/json',
    'Content-Type': 'application/json'
  } : {};

  return fetch(url, {
    method,
    body,
    headers,
  }).then(response =>
      response.json().then(json => ({ json, response }))
    ).then(({ json, response }) => {
      if (!response.ok) {
        return Promise.reject(json);
      }
      return Promise.resolve(json);
    });
};

const getQuizData = (id) => {
  const url = id ? API_ROOT + 'games/' + id : API_ROOT + 'games/';
  const method = id ? 'GET' : 'POST';
  return apiCall(url, method);
}

const postGameResult = (id, body) => {
  const url = API_ROOT + 'results';
  return apiCall(url, 'POST', JSON.stringify(body));
}

const getResultsByGame = (id) => {
  const url = API_ROOT + 'games/' + id + '/results';
  return apiCall(url, 'GET');
}

const Question = ({
  title,
  options,
  action,
  answer,
  currentAnswer,
}) => (
  <div className="Question">
    <h2 className="QuestionTitle">{title}</h2>
    {options.map(option => {
      return (
        <OptionButton
          isSelected={currentAnswer === option.value}
          isCorrect={currentAnswer && answer === option.value}
          showAnswer={typeof currentAnswer !== "undefined"}
          className="Button"
          onClick={() => action(option.value, answer)}
          key={option.value}
        >
          {option.label}
        </OptionButton>
      )
    })}
  </div>
);

const calcScore = (correct, incorrect) => Math.round((correct / (correct + incorrect)) * 100);

const Results = ({
  name,
  score,
  scores
}) => (
  <div className="Results">
    <p>Hoi {name}, jouw score is: {score}%</p>
    <div className="ResultsList">
      {scores.map((score, i) => {
        return (
          <div key={score.id}>{`${i + 1}. ${score.name} ${score.organisation} (${calcScore(score.correct_count, score.incorrect_count)}%)`}</div>
        );
      })}
    </div>
  </div>
);

const Progress = ({ current, total }) => (
  <div className="Progress">
    <div className="ProgressBar" style={{ width: `${current/total * 100}%` }} />
  </div>
);

class Quiz extends Component {
  constructor() {
    super();

    this.state = {
      gameId: null,
      index: undefined,
      questions: [],
      questionsCount: null,
      name: undefined,
      score: null,
      scores: [],
      organisation: undefined,
      answers: [],
      loading: false,
    };

    this.nextQuestion = this.nextQuestion.bind(this);
    this.renderResults = this.renderResults.bind(this);
    this.renderQuestions = this.renderQuestions.bind(this);
    this.startQuiz = this.startQuiz.bind(this);
    this.postResults = this.postResults.bind(this);
  }

  componentWillMount() {
    const gameId = window.location.pathname.split('/')[2] || '';

    getResultsByGame(gameId).then(jsonData => {
      this.setState({
        scores: jsonData,
      })
    });

    getQuizData(gameId).then(jsonData => {
      // update browser url
      history.pushState({}, `Game ${jsonData.id}`, `/game/${jsonData.id}`);

      // set data in state
      this.setState({
        gameId: jsonData.id,
        questions: jsonData.questions,
        questionsCount: jsonData.question_count,
      });
    });

  }

  nextQuestion(userAnswer, questionAnswer) {
    const nextIndex = this.state.index === undefined ? 0 : this.state.index + 1;
    const result = userAnswer.toString() === questionAnswer.toString() ? true : false;

    // TODO: show correct answer in UI
    // console.log(result);
    this.setState({
      answers: [...this.state.answers, userAnswer],
    });
    setTimeout(() => {
      this.setState({
        index: nextIndex,
      });
    }, DELAY);
  }

  postResults() {
    const answers = this.state.answers.map((answer, i) => ({
      question_id: this.state.questions[i].id,
      answer
    }));

    const body = {
      result: {
        game_id: this.state.gameId,
        name: this.state.name,
        organisation: this.state.organisation,
        answers
      }
    };

    return postGameResult(this.state.gameId, body).then(jsonData => {
      const score = calcScore(jsonData.correct_count, jsonData.incorrect_count);
      this.setState({
        score,
      })
    });
  }


  renderResults() {
    if (this.state.loading === false) {
      this.postResults();
      this.setState({ loading: true });
    }

    return (<Results name={this.state.name} scores={this.state.scores} score={this.state.score} />);
  }

  startQuiz() {
    this.setState({
      index: 0,
      name: this.refs.name.value || 'Anoniempje',
      organisation: this.refs.organisation.value || '-',
    });
  }

  renderQuestions() {
    const {
      index,
      questions,
    } = this.state;

    const style = {
      transition: 'transform .2s ease-out',
      transform: `translateY(${index % questions.length * -100}%)`
    };
    const currentAnswer = this.state.answers[this.state.index];

    return (
      <div>
        <div className="QuestionsList" style={style}>
          {this.state.questions.map((question, i) => {
            return (
              <Question
                key={i}
                action={this.nextQuestion}
                title={question.title}
                options={question.body.options}
                answer={question.body.answer}
                currentAnswer={currentAnswer}
              />
            );
          })}
        </div>
        <Progress current={index} total={questions.length} />
      </div>
    );
  }

  render() {
    const {
      index,
      questions,
    } = this.state;

    console.log(this.state);

    if (index + 1 > questions.length) {
      return this.renderResults();
    }

    if (index !== undefined) {
      return this.renderQuestions();
    }

    return (
      <div className="StartScreen">
        <div className="StartScreenHeader">
          <img className="Logo" src={logo} width="200" role="presentation" />
        </div>

        <div className="StartScreenForm">
          <label className="Label" htmlFor="name">Wat is je naam?</label>
          <input className="Field" id="name" type="text" ref="name" />

          <label className="Label" htmlFor="organisation">Waar werk je?</label>
          <input className="Field" id="organisation" type="text" ref="organisation" />

          <button
            className="Button"
            onClick={() => this.startQuiz()}
            children="Start Quiz"
          />
        </div>
      </div>
    );
  }
}

const OptionButton = ({
  answer,
  onClick,
  children,
  isCorrect,
  showAnswer,
  isSelected,
}) => (
  <button className="OptionButton" onClick={onClick}>
    <div className={`OptionButton--inside OptionButton--${(isCorrect && showAnswer) ? 'correct' : ''}${(!isCorrect && showAnswer) ? 'incorrect' : ''} ${(isSelected || isCorrect) ? 'OptionButton--selectedOrCorrect' : ''}`}>
      {(isCorrect && isSelected && showAnswer) ? "✓" : ""}
      {(!isCorrect && isSelected && showAnswer) ? "×" : ""}
    </div>
    {children}
  </button>
);

const App = () => (
  <div className="App">
    <Quiz />
  </div>
);

export default App;
