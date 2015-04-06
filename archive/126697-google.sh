#! /bin/bash
# Use /usr/local/bin/bash on FreeBSD
#
#Script: Google services
#Autor: Valentin "angenoir" COMTE.
#Version: 0.1
# Allow you to manage your google account by using the google tools in cli.
# Requires: zenity, googlecl, gdata-python-client (aka python-gdata) >= 1.3.0 (1.2.4 may work but some functions are not supported, see google documentation.)
#
# Note : Google calendar is not included, I can't made it works, so if you can, feel free to edit this script.
# /!\ IMPORTANTE NOTE ! Please, run these scripts (one script for each service) once in a term to configure your google account => http://code.google.com/p/googlecl/wiki/Manual
# This script is under the General Public License, so feel free to ameliorate it and share it !
#
#Let's initialize first window.
#Radio window where the user select the service he wants to use
service=$(zenity  --list --width 250 --height 270 --text "Which service would you like to use ?" --radiolist  --column "Pick" --column "Service" TRUE Blogger FALSE Contacts FALSE Docs FALSE Picasa FALSE Youtube)

#Analyze the choice
if [ "$service" = "Blogger" ]; then
	#If Blogger is selected, ask the user on what does he want to do
	task=$(zenity --list --width 450 --height 225 --text="What do you want to do ?" --title="What do you want to do ?" --radiolist --column "Pick" --column "Task" TRUE "List your posts" FALSE "Post an article" FALSE "Delete a post" FALSE "Tag a post")
		#Analyze answer
		if [ "$task" = "List your posts" ]; then 
			list=$(google blogger list title);
			list_url=$(google blogger list url-site);
			zenity --list --width 720 --height 450 --column "Your documents" --column "Url" "$list" "$list_url"
		break
		elif [ "$task" = "Post an article" ]; then 
			zenity --info --text "! Must be in .txt !"
			selected_post=$(zenity --file-selection)

			# Check if we have selected any files...
			if [ -z "$selected_post" ]; then
    				zenity --error --text="No file selected."
    				exit 0;
			
			fi
			post_name=$(zenity --entry --text "Specify the title of your post." --entry-text "Specify the title of your post.")
			post_tag=$(zenity --entry --text "Specify the tags of your post. Separated by a coma" --entry-text "Specify the tags of your post. i.e. post, test post, etc.")
			google blogger post --title "$post_name" --tag "$post_tag" "$selected_post"
		break
		elif [ "$task" = "Delete a post" ]; then
			post_name=$(zenity --entry --text "Specify the title of your post. If you're not sure, check the list of your posts." --entry-text "Specify the title of your post. If you're not sure, check the list of your posts.")
			zenity --info --text "This will delete "$post_name" are you sure ?"
			google blogger delete --title "$post_name"
		break
		elif [ "$task" = "Tag a post" ]; then
			post_name=$(zenity --entry --text "Specify the title of the post." --entry-text "Specify the title of the post.")
			post_tag=$(zenity --entry --text "Specify the tags of your post. Separated by a coma" --entry-text "Specify the tags of your post. i.e. post, test post, etc.")
			google blogger tag --title "$post_name" --tag "$post_tag"
		fi
break
elif [ "$service" = "Contacts" ]; then
	task=$(zenity --list --width 450 --height 225 --text="What do you want to do ?" --title="What do you want to do ?" --radiolist --column "Pick" --column "Task" TRUE "Add contact manually" FALSE "Add contacts by .csv file" FALSE "Export contacts to .csv file" FALSE "List all contacts")
	#Analyze answer
	if [ "$task" = "Add contact manually" ]; then 
		add_contact=$(zenity --entry --text "Specify your contact." --entry-text "John DUPONT-DOE,j.dupont-doe@myemail.tld")
		google contacts add "$add_contact"
	break
	elif [ "$task" = "Add contact by .csv file" ]; then
		add_contact=$(zenity --file-selection)

			# Check if we have selected any files...
			if [ -z "$add_contact" ]; then
    				zenity --error --text="No contact selected."
    				exit 0;
			fi
		google contacts add "$add_contact"
	break
	elif [ "$task" = "Export contacts to .csv file" ]; then
		contact_destination=$(zenity --file-selection --save --confirm-overwrite)
		google contacts list > "$contact_destination"
	break
	elif [ "$task" = "List all contacts" ]; then
		list=$(google contacts list name);
		list_mail=$(google contacts list email);
		zenity --list --width 600 --height 600 --column "Your contacts" --column "email" "$list" "$list_mail"
	fi
break
elif [ "$service" = "Docs" ]; then
	#If Google Docs is selected, ask the user on what does he want to do
	task=$(zenity --list --width 450 --height 225 --text="What do you want to do ?" --title="What do you want to do ?" --radiolist --column "Pick" --column "Task" TRUE "List your documents" FALSE "Upload a document" FALSE "Delete a document" FALSE "Edit a document" FALSE "Download a document")
		#Analyze answer
		if [ "$task" = "List your documents" ]; then 
			list=$(google docs list title);
			list_url=$(google docs list url-direct);
			zenity --list --width 720 --height 450 --column "Your documents" --column "Url" "$list" "$list_url"
		break
		elif [ "$task" = "Upload a document" ]; then
			selected_doc=$(zenity --file-selection)
				# Check if we have selected any files...
				if [ -z "$selected_doc" ]; then
    					zenity --error --text="No document selected."
    				exit 0;
				fi
			google docs upload "$selected_doc"
				#Check, if process still exist then show a pop-up window.
				pid_docs=$(pidof /usr/bin/python /usr/bin/google docs)
				pid_docs2=$(kill -0 "$pid_docs")
				while kill -0 $pid_docs >/dev/null 
				do sleep 1 
				done
				zenity --info --text "Upload complete !"
		break
		elif [ "$task" = "Edit a document" ]; then
			modify_doc=$(zenity --entry --text "Which document should be modified ?" --entry-text "The name of your document goes here, check the list if you're not sure.")
			editor=$(zenity --entry --text "With which editor the document should be modified ?" --entry-text "Type the name of your editor here i.e. vim, gedit, emacs, nano etc.")
			google docs edit -n "$modify_doc" --editor "$editor"
		break
		elif [ "$task" = "Delete a document" ]; then
			#specify document name.
			document_delete=$(zenity --entry --text "Specify the exact name of the document, use list your docs if you're not sure." --entry-text "Specify the exact name of the document, use list your docs if you're not sure.")
			#Warning
			zenity --info --text "You're gonna delete this document $video_delete are you sure ?"
			google docs delete -n "$document_delete"
		break
		elif [ "$task" = "Download a document" ]; then
			#specify document name.
			document_download=$(zenity --entry --text "Specify the exact name of the document, use list your docs if you're not sure." --entry-text "Specify the exact name of the document, use list your docs if you're not sure.")
			#Must specify a directory, must select it and not just click on Validate :( You must'nt specify a file name too.
			document_destination=$(zenity --file-selection --directory --save --confirm-overwrite)
			google docs get -n "$document_download" "$document_destination"
			#Check, if process still exist then show a pop-up window.
			pid_doc=$(pidof /usr/bin/python /usr/bin/google doc)
			pid_doc2=$(kill -0 "$pid_doc")
			while kill -0 $pid_doc >/dev/null 
			do sleep 1 
			done
				zenity --info --text "Download complete !"
		fi
	break
elif [ "$service" = "Picasa" ]; then
	#If Picasa is selected, ask the user on what does he want to do
	task=$(zenity --list --width 450 --height 225 --text="What do you want to do ?" --title="What do you want to do ?" --radiolist --column "Pick" --column "Task" TRUE "Create an album" FALSE "Delete photo or album" FALSE "Download an album" FALSE "List" FALSE "Add photo to an album" FALSE "Tag photos")
	if [ "$task" = "Create an album" ]; then
	name_album=$(zenity --entry --text "Name of the album" --entry-text "Name of the album");
	tag_album=$(zenity --entry --text "Tags of the album" --entry-text "Tags of the album i.e. Vermont, USA, etc.");
	direcotry_or_photo=$(zenity --list --text "Upload a single photo or a directory ?" --title "Upload a single photo or a directory ?" --radiolist --column "Pick" --column "Choice" TRUE "directory" FALSE "single photo")
		if [ "$direcotry_or_photo" = "directory" ]; then
			selected_dir=$(zenity --file-selection --directory)
			output_name=$(zenity --entry --text "Define the title of your album." --entry-text "Define the title of your album.")
			output_tags=$(zenity --entry --text "Add tags to your album, separated by coma" --entry-text "example, example1, bla, etc.")
			google picasa create --title "$output_name" --tag "$output_tags" "$selected_dir"
		break
		elif [ "$direcotry_or_photo" = "single photo" ]; then
			selected_pic=$(zenity --file-selection)
			output_name=$(zenity --entry --text "Define the title of your album." --entry-text "Define the title of your album.")
			output_tags=$(zenity --entry --text "Add tags to your album, separated by coma" --entry-text "example, example1, bla, etc.")
			google picasa create --title "$output_name" --tag "$output_tags" "$selected_pic"
		fi
	break
	elif [ "$task" = "Delete photo or album" ]; then
		output_name=$(zenity --entry --text "Enter the name of the poto/album." --entry-text "If you're not sure check your album/photo list !")
		google picasa delete -n "$output_name"
	break
	elif [ "$task" = "Download an album" ]; then
		#specify an album name.
		album_download=$(zenity --entry --text "Specify the exact name of the album/photo, use list your albums if you're not sure." --entry-text "Specify the exact name of album/photo, use list your albums if you're not sure.")
		#Must specify a directory, must select it and not just click on Validate :( You must'nt specify a file name too.
		album_destination=$(zenity --file-selection --directory --save --confirm-overwrite)
		google picasa get -n "$album_download" "$album_destination"
		#Check, if process still exist then show a pop-up window.
			pid_pic=$(pidof /usr/bin/python /usr/bin/google picasa)
			pid_pic2=$(kill -0 "$pid_doc")
			while kill -0 $pid_pic >/dev/null 
				do sleep 1 
			done
				zenity --info --text "Download complete !"
		break
	elif [ "$task" = "Add photo to an album" ]; then
		pic=$(zenity --file-selection --multiple)
		album=$(zenity --entry --text "Specify the exact name of the album/photo, use list your albums if you're not sure." --entry-text "Specify the exact name of album/photo, use list your albums if you're not sure.")
		google picasa post --title "$album" "$pic"
			#Check, if process still exist then show a pop-up window.
			pid_pic=$(pidof /usr/bin/python /usr/bin/google picasa)
			pid_pic2=$(kill -0 "$pid_doc")
			while kill -0 $pid_pic >/dev/null 
				do sleep 1 
			done
				zenity --info --text "Upload complete !"
	break
	elif [ "$task" = "Tag photos" ]; then
		album=$(zenity --entry --text "Specify the exact name of the album/photo, use list your albums if you're not sure." --entry-text "Specify the exact name of album/photo, use list your albums if you're not sure.")
		tag=$(zenity --entry --text "Enter the tags here" --entry-text "example, example1, bla, etc.")
		google picasa tag -n "$album" --tags "$tag"
	break
	elif [ "$task" = "List" ]; then
		list=$(google picasa list title);
		list_url=$(google picasa list url-direct);
		zenity --list --width 720 --height 200 --column "Your photos" --column "Url" "$list" "$list_url"
	fi
break
elif [ "$service" = "Youtube" ]; then
	#If Youtube is selected, ask the user on what does he want to do
	task=$(zenity --list --width 450 --height 225 --text "What do you want to do ?" --title "What do you want to do ?" --radiolist --column "Pick" --column "Task" TRUE "Upload a video" FALSE "List your videos" FALSE "Delete your video" FALSE "Edit the category or the tags of your video")
		if [ "$task" = "Upload a video" ]; then 
			zenity --info --text "! You can select only this video type => mp4 avi 3gp mov wmv !"
			selected_video=$(zenity --file-selection)

			# Check if we have selected any files...
			if [ -z "$selected_video" ]; then
    				zenity --error --text="No video selected."
    				exit 0;
			fi

			#Ask for video category
			output_category=$(zenity --list --text="choose a category" --title="Choose a category" --radiolist  --column "Pick" --column "Category" TRUE Film FALSE Autos FALSE Music FALSE Travel FALSE Shortmov FALSE Videoblog FALSE Games FALSE Comedy FALSE Entertainment FALSE Education FALSE Howto FALSE Nonprofit FALSE Tech FALSE Movies FALSE Trailers)

			#Ask for tags
			output_tags=$(zenity --entry --text "Add tags to your video, separated by coma" --entry-text "example, example1, bla, etc.")

			#post the video
			google youtube post --tags "$output_tags" --category "$output_category" "$selected_video"

			#Check, if process still exist then show a pop-up window.
			pid_youtube=$(pidof /usr/bin/python /usr/bin/google youtube post)
			pid_youtube2=$(kill -0 "$pid_youtube")
			while kill -0 $pid_youtube >/dev/null 
			do sleep 1 
			done
				zenity --info --text "Upload complete !"
			break
	elif [ "$task" = "List your videos" ]; then
		list=$(google youtube list title);
		list_url=$(google youtube list url-direct);
		zenity --list --width 720 --height 200 --column "Your video" --column "Url" "$list" "$list_url"
	break
	elif [ "$task" = "Delete your video" ]; then
		#specify video name.
		video_delete=$(zenity --entry --text "Specify the exact name of the video, use list your videos if you're not sure." --entry-text "Specify the exact name of the video, use list your videos if you're not sure.")
		#Warning
		zenity --info --text "You're gonna delete this video $video_delete are you sure ?"
		google youtube delete -n "$video_delete"
	break
	elif [ "$task" = "Edit the category or the tags of your video" ]; then
		video_name=$(zenity --entry --text "Specify the exact name of the video, use list your videos if you're not sure." --entry-text "Specify the exact name of the video, use list your videos if you're not sure.")
		new_tags=$(zenity --entry --text "Specify new tags." --entry-text "Specify new tags")
		new_category=$(zenity --list --text="choose a new category" --title="Choose a new category" --radiolist  --column "Pick" --column "Category" TRUE Film FALSE Autos FALSE Music FALSE Travel FALSE Shortmov FALSE Videoblog FALSE Games FALSE Comedy FALSE Entertainment FALSE Education FALSE Howto FALSE Nonprofit FALSE Tech FALSE Movies FALSE Trailers)
		google youtube tag -n "$video_name" --tag "$new_tags" --category "$new_category"
	fi
break
else
	zenity --error --text "Something bad happens. Error."
fi
