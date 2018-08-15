# Automatic Email composer/sender
--- 
## 1\. Generate a new template
#### Execute 
```
./generate myTemplate
```
and the following files will be generated:
*	./templates/**myTemplate**/zh.txt
*	./templates/**myTemplate**/en.txt
*	./templates/**myTemplate**/subject\_zh.txt
*	./templates/**myTemplate**/subject\_en.txt
#### You should edit all of those files, since your letters will be generated based on the contents in them.

####	Below is a description of the files
* _./templates/myTemplate/zh.txt_
> contains letter contents in Chinese, where bash variables(defined in the first line of _XxxData.csv_) and subshell syntax can be used to compose slightly different contents based on the receiver.
* _./templates/myTemplate/en.txt_
> contains letter contents in English, where bash variables(defined in the first line of _XxxData.csv_) and subshell syntax can be used to compose slightly different contents based on the receiver.
* _./templates/myTemplate/subject\_zh.txt_
> contains letter Subject in Chinese
* _./templates/myTemplate/subject\_en.txt_
> contains letter Subject in English
* _./XXX\_data.csv_ (**will not be generated**)
> contains data of the receivers. You should create this file manually, whose contents should resemble the following table.

> *num*|*address*|*name*|*isEng*|isClose|...
> ---:|:---:|:---:|:---:|:---:|---
> 1|xxx@gmail.com|uncle Jack|y|y|...
> 2|yyy@yahoo.com|Tim|y|n|...
> .|.|.|.|.|...
> .|.|.|.|.|...
> .|.|.|.|.|...

> Where the first row is always the variable names that you will use in the template files (zh.txt, en.txt)
> Currently, the italicized variables (first 4) are necessary, so be sure to include them.
> #### A description of variables
> * **num**: a unique number identifying each receiver
> * **address**: the email address of the receiver
> * **name**: the name of the receiver
> * **isEng**: whether the receiver uses English(as opposed to Chinese)
> ####**Note**: By convention, boolean variables will have a name _isXXX_, and its true value is 'y', anything else is false.

---
## 2\. Compose letters
#### Execute
```
./compose myTemplate XXX\data.csv
```
#### to compose letters.
#### You can browse and check the generated letters in ./letters/myTemplate/
---
## 3\. Send your letters
#### When letters are successfully composed, execute
```
./send myTemplate
```
#### and follow the interactive instruction to send letters
