From: Vincent Bernat <bernat@luffy.cx>
Subject: Re: [V9fs-developer] 9p/overlayfs: read error when reading an empty file
Date: Sat, 03 Oct 2015 19:07:01 +0200
Message-ID: <m3pp0v51ai.fsf@neo.luffy.cx>
References: <87oai9hui2.fsf@zoro.exoscale.ch>
	<877fowita7.fsf@zoro.exoscale.ch> <20150817141137.GA15883@u-michard>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from bart.luffy.cx ([78.47.78.131]:45903 "EHLO bart.luffy.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbbJCRNJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Sat, 3 Oct 2015 13:13:09 -0400
In-Reply-To: <20150817141137.GA15883@u-michard> (Dominique Martinet's message
	of "Mon, 17 Aug 2015 16:11:37 +0200")
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Dominique Martinet <dominique.martinet@cea.fr>
Cc: Eric Van Hensbergen <ericvh@gmail.com>, Latchesar Ionkov <lucho@ionkov.net>, Ron Minnich <rminnich@sandia.gov>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, David Howells <dhowells@redhat.com>, v9fs-developer@lists.sourceforge.net

 =E2=9D=A6 17 ao=C3=BBt 2015 16:11 +0200, Dominique Martinet <dominique=
=2Emartinet@cea.fr>=C2=A0:

>> For this bug, I was able to bisect to this commit:
>>=20
>> 4bacc9c9234c7c8eec44f5ed4e960d9f96fa0f01 is the first bad commit
>>
>> commit 4bacc9c9234c7c8eec44f5ed4e960d9f96fa0f01
>> Author: David Howells <dhowells@redhat.com>
>> Date:   Thu Jun 18 14:32:31 2015 +0100
>>=20
>>     overlayfs: Make f_path always point to the overlay and f_inode t=
o the underlay
>>=20
>> In fact, any file reading of files present in the lower layer will l=
ead
>> to this. No need to try to switch root or anything complex.
>
> Hmm, that is going to be annoying to fix, since we use
> file->f_path.dentry to get a new fid to the same file (clone), and
> current code pretty much depends on that...
>
> I guess it used to work because file->f_op, file->f_inode and
> file->f_path used to all be from the same layer, which isn't the case
> anymore.
>
>
> Does any overlayfs person reading this know if it's still possible to
> get the right dentry at this point?
> I'm sure the object exists somewhere in memory, but it could be annoy=
ing
> to find.

Hi Dominique!

Did you get any feedback on this? The problem is unfortunately still
present in 4.3-rc3.
--=20
Let the machine do the dirty work.
            - The Elements of Programming Style (Kernighan & Plauger)
