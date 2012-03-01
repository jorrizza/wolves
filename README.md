Wolves
======

Wolves hides arbitrary data in PNG files. It supports spanning archives
in a number of image files, obfuscation and encryption.

Goal
----

With the current wide spread image hosting possibilities on the
Internet one can easily leaverage this free hosting to piggyback some
arbitrary data. Especially data which should not easily be found can
be hidden in plain sight without anyone knowing. This, of course, is
security by obscurity. Therefore encryption is mandatory.

How it works
------------

Wolves is the successor of Foxes, a tool that adds executable Ruby
code to PNG files. Foxes added the 'ruby' FourCC to the PNG file and
put the code in. Wolves tries to be a little more sneaky. One could
easily strip out any non-RFC2083 chunks from a PNG file and completely
destroy the added data. Wolves tries to be completely RFC2083
compliant. It hides the data in a number of tEXt chunks, originally
meant for storing textual data. Wolves takes your data, chops it up in
a number of parts, encodes it in ISO-8859-1 and adds the tEXt chunks
to a number of PNG files. This is the most efficient method of hiding
data. Of course image hosting sites could strip out all data except
the data necessary to display the image, but none actually do at this
point. Once image hosting sites start doing this, Wolves can easily be
rewritten to hide data in the alpha channel. Because this is less
efficient, the tEXt method is preferred. Some hosting sites convert
the image to another format though. This also destroys the data. At
this point there is no efficient method of keeping the data when that
happens.
