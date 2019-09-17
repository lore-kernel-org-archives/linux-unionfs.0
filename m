Return-Path: <lange@informatik.uni-koeln.de>
From: Thomas Lange <lange@informatik.uni-koeln.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <23936.61171.958066.468358@informatik.uni-koeln.de>
Date: Tue, 17 Sep 2019 16:34:27 +0200
Subject: Re: can overlayfs work wit NFS v4 as lower fs?
In-Reply-To: <CAJfpegu0FprqEkgU2rDCiu-2nr=jwzS3wNZAj6oV-DEdv+v=eQ@mail.gmail.com>
References: <23935.36189.612024.342204@informatik.uni-koeln.de>
	<CAJfpegsk30wCJY1WaQWJOibfw35TGYxUuPBYx8v7xObJBSgTAw@mail.gmail.com>
	<23936.43370.127198.222503@informatik.uni-koeln.de>
	<CAJfpegu0FprqEkgU2rDCiu-2nr=jwzS3wNZAj6oV-DEdv+v=eQ@mail.gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

>>>>> On Tue, 17 Sep 2019 15:26:28 +0200, Miklos Szeredi <miklos@szeredi.hu> said:

    > Ah, the way to disable these is to disable acl on the exported filesystem.  I.e.
    > mount -oremount,noacl $EXPORTED_FS
That works perfect for me. Thanks a lot for your help.

It would be nice to add a note about this in the kernel
overlayfs.txt. What about this:

 The lower filesystem can be any filesystem supported by Linux and does
-not need to be writable.  The lower filesystem can even be another
+not need to be writable. If you are using an NFS v4 mount as lower
+filesystem, you should disable acl on the exported filesystem.
+The lower filesystem can even be another

-- 
regards Thomas
