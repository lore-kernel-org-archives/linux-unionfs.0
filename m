From: Atom2 <ariel.atom2@web2web.at>
Subject: stat inconsistency with overlayfs
Date: Fri, 20 Feb 2015 19:15:23 +0100
Message-ID: <54E779BB.8030209@web2web.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from grace.univie.ac.at ([131.130.3.115]:60776 "EHLO
	grace.univie.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbbBTSWA (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 20 Feb 2015 13:22:00 -0500
Received: from joan.univie.ac.at ([131.130.3.110] helo=joan.univie.ac.at)
	by grace.univie.ac.at with esmtps (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
	(Exim 4.85)
	(envelope-from <ariel.atom2@web2web.at>)
	id 1YOs6k-00084K-BM
	for linux-unionfs@vger.kernel.org; Fri, 20 Feb 2015 19:15:22 +0100
Received: from zeus.herrenhauspark.com ([92.243.35.23] helo=[192.168.19.32])
	by joan.univie.ac.at with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
	(Exim 4.85)
	(envelope-from <ariel.atom2@web2web.at>)
	id 1YOs6k-0005Od-49
	for linux-unionfs@vger.kernel.org; Fri, 20 Feb 2015 19:15:22 +0100
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

I am using find with its printf "%D" option (provides the same=20
information as stats device information "%d" - device number in decimal=
)=20
to figure out whether a file system entry resides in the r/o lowerdir o=
r=20
the r/w upperdir of an overlayfs mounted filesystem. I distinguish=20
between the two by getting the device number from a (plain) file know t=
o=20
be in the upperdir.

The use case behind that is to be able to backup only files from the=20
upperdir for several systems sharing a common lowerdir filesystem. I=20
have used that (scripted approach via rsync) now for quiet some time an=
d=20
a few kernels back and it seemed to have worked very well.

Currently I am using kernel 3.17.7 on gentoo and I seem to observe a=20
strange behaviour (which I do not recall to have seen before on 3.13 an=
d=20
3.11) with my approach as follows:

=2E) plain files still work and the device number is correct
=2E) directories, however, always seem to reside in the lowerdir - even=
=20
thoguh they do not exist there; in fact there's not a single file in th=
e=20
whole filesystem hierarchy that, according to stat/find, seems to resid=
e=20
in the upperdir:

please see the stat output for a file and a directory, both residing in=
=20
the same (parent) directory which is completely located in the upperdir=
=20
(and does not at all exist in the lowerdir):
# stat serial
   File: =E2=80=98serial=E2=80=99
   Size: 17              Blocks: 8          IO Block: 4096   regular fi=
le
Device: ca03h/51715d    Inode: 88          Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root=
)
Access: 2014-02-19 19:01:56.278161346 +0100
Modify: 2014-02-19 19:01:56.278161346 +0100
Change: 2014-02-19 19:01:56.278161346 +0100
  Birth: -
#
# stat certs/
   File: =E2=80=98certs/=E2=80=99
   Size: 4096            Blocks: 8          IO Block: 4096   directory
Device: dh/13d  Inode: 331140      Links: 2
Access: (0700/drwx------)  Uid: (    0/    root)   Gid: (    0/    root=
)
Access: 2014-04-26 14:08:47.337968562 +0200
Modify: 2014-02-19 18:55:58.458161346 +0100
Change: 2014-02-19 18:55:58.458161346 +0100
  Birth: -

=46or comparision, please see the stat of /bin which only resides in th=
e=20
lowerdir and does not exist in the upperdir:
# stat /bin
   File: =E2=80=98/bin=E2=80=99
   Size: 4096            Blocks: 8          IO Block: 4096   directory
Device: dh/13d  Inode: 401777      Links: 2
Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root=
)
Access: 2015-02-20 17:50:24.066368607 +0100
Modify: 2015-02-09 17:51:18.000000000 +0100
Change: 2015-02-09 23:58:06.011825328 +0100
  Birth: -

I do not think that this is the expected behaviour and I am pretty=20
confident that this was different on older kernels - or am I missing=20
anything/doing anything wrong here?

Thanks and regards Atom2
--
To unsubscribe from this list: send the line "unsubscribe linux-unionfs=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
