Return-Path: <zohar@linux.ibm.com>
Subject: Re: PROBLEM: IMA xattrs not written on overlayfs
From: Mimi Zohar <zohar@linux.ibm.com>
Date: Fri, 28 Sep 2018 15:06:00 -0400
In-Reply-To: <0e1ba67f-3091-2d56-a464-07e1a8251e5e@suse.de>
References: <81a0a75d-bd4e-25ef-b41b-adb65ac6dee8@suse.de>
	 <1536345954.3792.173.camel@linux.ibm.com>
	 <e74f411a-d3fa-6f10-9ac6-d070f7d50220@suse.de>
	 <1538153671.3713.4.camel@linux.ibm.com>
	 <0e1ba67f-3091-2d56-a464-07e1a8251e5e@suse.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-Id: <1538161560.3702.12.camel@linux.ibm.com>
To: Ignaz Forster <iforster@suse.de>, miklos@szeredi.hu, linux-unionfs@vger.kernel.org, linux-integrity@vger.kernel.org
Cc: Fabian Vogt <fvogt@suse.de>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, 2018-09-28 at 20:24 +0200, Ignaz Forster wrote:
> Am 28.09.18 um 18:54 schrieb Mimi Zohar:
> > On Mon, 2018-09-10 at 11:17 +0200, Ignaz Forster wrote:
> >> Am 07.09.18 um 20:45 schrieb Mimi Zohar:
> >>>> A small example for reproduction (on a system with IMA appraisal):
> >>>> # OVERLAYFS_TEST_DIR=`mktemp -d`
> >>>> # mkdir "${OVERLAYFS_TEST_DIR}/upper"
> >>>> # mkdir "${OVERLAYFS_TEST_DIR}/work"
> >>>> # mount -t overlay -o lowerdir=/etc,upperdir="${OVERLAYFS_TEST_DIR}
> >>>> /upper",workdir="${OVERLAYFS_TEST_DIR}/work" overlay /etc
> >>>> #
> >>>> # rm -f /etc/test.txt
> >>>> # echo Test > /etc/test.txt
> >>>> # cat /etc/test.txt
> >>>> cat: /etc/test.txt: Permission denied
> >>>> # ls -s /etc/test.txt
> >>>> 4 /etc/test.txt # <- The contents are there
> >>>> # getfattr -m . -d /etc/test.txt
> >>>> # # <- The hash isn't
> >>>>
> > The file size is still 0, when ima_check_last_writer() calls
> > ima_update_xattr(), which tries to calculate the file hash and write
> > it out an security.ima.
> 
> We found out that when forcibly setting the read flag in 
> ovl_open_realfile as seen in the attached patch the IMA attributes will 
> be set correctly again. It seems IMA cannot read the file contents and 
> thus cannot create the hash any more.
> 
> This is obviously not ready for production, but the best I currently have.

Yeah, having file read access is definitely required to calculate a
file hash.  If it helps, you could make this change in IMA and then
revert it after calculating the file hash.

Mimi
