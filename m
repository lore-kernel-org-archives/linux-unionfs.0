Return-Path: <zohar@linux.ibm.com>
Subject: Re: PROBLEM: IMA xattrs not written on overlayfs
From: Mimi Zohar <zohar@linux.ibm.com>
Date: Fri, 28 Sep 2018 12:54:31 -0400
In-Reply-To: <e74f411a-d3fa-6f10-9ac6-d070f7d50220@suse.de>
References: <81a0a75d-bd4e-25ef-b41b-adb65ac6dee8@suse.de>
	 <1536345954.3792.173.camel@linux.ibm.com>
	 <e74f411a-d3fa-6f10-9ac6-d070f7d50220@suse.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <1538153671.3713.4.camel@linux.ibm.com>
To: Ignaz Forster <iforster@suse.de>, miklos@szeredi.hu, linux-unionfs@vger.kernel.org, linux-integrity@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, 2018-09-10 at 11:17 +0200, Ignaz Forster wrote:
> Am 07.09.18 um 20:45 schrieb Mimi Zohar:
> >> A small example for reproduction (on a system with IMA appraisal):
> >> # OVERLAYFS_TEST_DIR=`mktemp -d`
> >> # mkdir "${OVERLAYFS_TEST_DIR}/upper"
> >> # mkdir "${OVERLAYFS_TEST_DIR}/work"
> >> # mount -t overlay -o lowerdir=/etc,upperdir="${OVERLAYFS_TEST_DIR}
> >> /upper",workdir="${OVERLAYFS_TEST_DIR}/work" overlay /etc
> >> #
> >> # rm -f /etc/test.txt
> >> # echo Test > /etc/test.txt
> >> # cat /etc/test.txt
> >> cat: /etc/test.txt: Permission denied
> >> # ls -s /etc/test.txt
> >> 4 /etc/test.txt # <- The contents are there
> >> # getfattr -m . -d /etc/test.txt
> >> # # <- The hash isn't
> >>
> > 
> > Thank you for providing the example.  Also on a linux-4.18.0-rcX test
> > kernel, the file hash isn't being written out either.  The builtin
> > "appraise_tcb" policy (eg. specified as "ima_policy=appraise_tcb" on
> > the boot command) has a tmpfs dont_appraise rule.
> 
> Putting the mount point into /tmp may have been a bad example, however 
> at least on my system /tmp is mounted from a btrfs subvolume. Same with 
> /var, which I'm using for my personal tests.

The file size is still 0, when ima_check_last_writer() calls
ima_update_xattr(), which tries to calculate the file hash and write
it out an security.ima.

Mimi
