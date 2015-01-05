Return-Path: <fabian.sturm@aduu.de>
From: Fabian Sturm <fabian.sturm@aduu.de>
Subject: Multiple lower layers - presedence?
Date: Mon, 05 Jan 2015 02:00:53 +0100
Message-ID: <1997646.dsfVWM3xr5@debian-desktop-mine>
Content-Type: multipart/alternative; boundary="nextPart1490347.URqbfjAPgT"
Content-Transfer-Encoding: 7Bit
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu
List-ID: <linux-unionfs@vger.kernel.org>

This is a multi-part message in MIME format.

--nextPart1490347.URqbfjAPgT
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

The current documentation states the following:

Multiple lower layers
---------------------

Multiple lower layers can now be given using the the colon (":") as a
separator character between the directory names.  For example:

  mount -t overlay overlay -olowerdir=/lower1:/lower2:/lower3 /merged

As the example shows, "upperdir=" and "workdir=" may be omitted.  In that 
case
the overlay will be read-only.

Consider the case /lower1/A and /lower2/A exist.
What is part of the api - that it is undefined or that one takes presedence 
over the other?
It would be nice to have this clarified in the documentation.

Thanks,
Fabian

--nextPart1490347.URqbfjAPgT
Content-Transfer-Encoding: 7Bit
Content-Type: text/html; charset="us-ascii"

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN" "http://www.w3.org/TR/REC-html40/strict.dtd">
<html><head><meta name="qrichtext" content="1" /><style type="text/css">
p, li { white-space: pre-wrap; }
</style></head><body style=" font-family:'DejaVu Sans'; font-size:9pt; font-weight:400; font-style:normal;">
<pre style=" margin-top:12px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"><span style=" font-family:'Courier New,courier';">The current documentation states the following:</span></pre>
<pre style="-qt-paragraph-type:empty; margin-top:12px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; font-family:'Courier New,courier';"><br /></pre>
<pre style=" margin-top:12px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"><span style=" font-family:'Courier New,courier';">Multiple lower layers</span></pre>
<pre style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"><span style=" font-family:'Courier New,courier';">---------------------</span></pre>
<pre style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; font-family:'Courier New,courier';"><br /></pre>
<pre style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"><span style=" font-family:'Courier New,courier';">Multiple lower layers can now be given using the the colon (&quot;:&quot;) as a</span></pre>
<pre style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"><span style=" font-family:'Courier New,courier';">separator character between the directory names.  For example:</span></pre>
<pre style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; font-family:'Courier New,courier';"><br /></pre>
<pre style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"><span style=" font-family:'Courier New,courier';">  mount -t overlay overlay -olowerdir=/lower1:/lower2:/lower3 /merged</span></pre>
<pre style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; font-family:'Courier New,courier';"><br /></pre>
<pre style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"><span style=" font-family:'Courier New,courier';">As the example shows, &quot;upperdir=&quot; and &quot;workdir=&quot; may be omitted.  In that case</span></pre>
<pre style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"><span style=" font-family:'Courier New,courier';">the overlay will be read-only.</span></pre>
<pre style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:12px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; font-family:'Courier New,courier';"><br /></pre>
<pre style=" margin-top:0px; margin-bottom:12px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"><span style=" font-family:'Courier New,courier';">Consider the case /lower1/A and /lower2/A exist.</span></pre>
<pre style=" margin-top:0px; margin-bottom:12px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"><span style=" font-family:'Courier New,courier';">What is part of the api - that it is undefined or that one takes presedence over the other?</span></pre>
<pre style=" margin-top:0px; margin-bottom:12px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"><span style=" font-family:'Courier New,courier';">It would be nice to have this clarified in the documentation.</span></pre>
<pre style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:12px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; font-family:'Courier New,courier';"><br /></pre>
<pre style=" margin-top:0px; margin-bottom:12px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"><span style=" font-family:'Courier New,courier';">Thanks,</span></pre>
<pre style=" margin-top:0px; margin-bottom:12px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"><span style=" font-family:'Courier New,courier';">Fabian</span></pre></body></html>
--nextPart1490347.URqbfjAPgT--
