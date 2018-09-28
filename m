Return-Path: <fvogt@suse.de>
From: Fabian Vogt <fvogt@suse.de>
Subject: Re: PROBLEM: IMA xattrs not written on overlayfs
Date: Fri, 28 Sep 2018 21:37:40 +0200
Message-ID: <2170726.hUdX192fWn@linux-e202.suse.de>
In-Reply-To: <0e1ba67f-3091-2d56-a464-07e1a8251e5e@suse.de>
References: <81a0a75d-bd4e-25ef-b41b-adb65ac6dee8@suse.de> <1538153671.3713.4.camel@linux.ibm.com> <0e1ba67f-3091-2d56-a464-07e1a8251e5e@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"
To: Ignaz Forster <iforster@suse.de>
Cc: Mimi Zohar <zohar@linux.ibm.com>, miklos@szeredi.hu, linux-unionfs@vger.kernel.org, linux-integrity@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Hi,

I'm the other person Ignaz refers to when he wrote "we".

Am Freitag, 28. September 2018, 20:24:47 CEST schrieb Ignaz Forster:
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

In ima_crypto.c, ima_calc_file_hash_{atfm,tfm} we can find this hack (?),
which allows to read even through a WRONLY file:

        if (!(file->f_mode & FMODE_READ)) {
                file->f_mode |= FMODE_READ;
                read = 1;
        }

        integrity_kernel_read(file, ...);

        if (read)
                file->f_mode &= ~FMODE_READ;

In overlayfs since 4.19, it has a private struct file* for the internal filp
pointing to either lower or upper, which is not affected by this change to
the overlayfs' file's f_mode. Thus we get -EBADF back from
integrity_kernel_read -> ... -> ovl_read_iter -> vfs_iter_read.
That was not visible in any logs as IMA ignores -EBADF returned from
ima_calc_file_hash.

Before 4.19, overlayfs used d_real so there was no layer between
integrity_kernel_read and the real filp which means that the f_mode toggle in
ima had the desired effect.

> This is obviously not ready for production, but the best I currently have.

A better alternative for this is to set FMODE_READ temporarily in the private
filp during the call to vfs_iter_read in ovl_read_iter but IIRC we tried that
once and it was not enough. Maybe the test was just incomplete though.

Thanks,
Fabian

> Ignaz
