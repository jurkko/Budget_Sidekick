import 'package:budget_sidekick/features/number_trivia/data/repositories/number_trivia_repository.dart';
import 'package:budget_sidekick/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:budget_sidekick/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import  'package:flutter_test/flutter_test.dart';

class MockNumberTriviaRepository extends Mock 
  implements NumberTriviaRepository{}

void main(){
  GetConcreteNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

final tNumber = 1; //test number
final tNumberTrivia = NumberTrivia(number: 1, text:'test' );

test(
    'should get trivia for the number from the repository',
    () async {
      //arrange
      when(mockNumberTriviaRepository.getConcreteNumberTrivia(any))
      .thenAnswer((_) async => Right(tNumberTrivia));
      //act
      final result = await usecase.execute(number: tNumber);
      //assert
      expect(result, Right(tNumberTrivia));
      verify(mockNumberTriviaRepository.getRandomNumberTrivia(tNumber));
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    
    },
  );

}
  