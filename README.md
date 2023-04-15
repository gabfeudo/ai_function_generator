# How to use ai_function_generator
## 1. Prepare your machine
1. Generate your API key from you [OpenAI](https://platform.openai.com/) account
2. Set your OpenAI API key as environment variable named **OPENAI_API_KEY** (tutorials for [MacOS](https://phoenixnap.com/kb/set-environment-variable-mac), [Windows](https://docs.oracle.com/en/database/oracle/machine-learning/oml4r/1.5.1/oread/creating-and-modifying-environment-variables-on-windows.html) & [Linux](https://linuxize.com/post/how-to-set-and-list-environment-variables-in-linux/)). 

**ℹ️ Tip**: If `.bash_profile` doesn't work, try to set the env variable inside `.zshrc` file

## 2. Install dependencies
Run the following commands inside your project to install the required libraries (`ai_function`, `ai_function_generator` and `build_runner`):

```
flutter pub add --dev build_runner
flutter pub add --dev ai_function_generator
flutter pub add ai_function
```

## 3. Annotate your classes
Create new file called `example_class.dart` and inside paste the following code:
```
import 'package:ai_function/ai_function.dart';

part 'example_class.g.dart';

@AiGenerable()
abstract class ExampleClass {
	/// Locks the screen in portrait up
	@AiFunction()
	void lockInPortraitMode();
}
```

## 4. Run the AI generator ✨
Run the following command from the console: `flutter pub run build_runner watch --delete-conflicting-outputs`

**ℹ️ Tip**: the `watch` directive in the previous command will tell to `build_runner` to remain executed and to generate code every time you save the file. Replace it with `build` to run the generator only once.

Now you can use the generated class like this:

```
final myClass = ExampleClassImpl();
myClass.lockInPortraitMode();
```
