Return-Path: <zohar@linux.ibm.com>
Subject: Re: [Fwd: Re: EVM: Permission denied with overlayfs]
From: Mimi Zohar <zohar@linux.ibm.com>
Date: Thu, 20 Dec 2018 11:39:09 -0500
In-Reply-To: <CAOQ4uxh=bx_XKjCc88O5+Z_+xJvudp8PgWkaOds1JUEhmKZL3A@mail.gmail.com>
References: <1545233975.3954.8.camel@linux.ibm.com>
	 <1545234449.3954.14.camel@linux.ibm.com>
	 <CAOQ4uxgG9yu-dOgOZyFnck+=ZjsoDe0SCJ6S-4+s0kB6mH2Maw@mail.gmail.com>
	 <1545245504.3954.51.camel@linux.ibm.com>
	 <CAOQ4uxiv_Pcm1zOr3N+=ySqePvRkqoraH6Xkja3Z9WeywDpt3g@mail.gmail.com>
	 <1545303183.4317.15.camel@linux.ibm.com>
	 <CAOQ4uxgoNSo3BXMB9UTZx=hWKRQ0iMY0ooucuM0Eg7sNFhHFVA@mail.gmail.com>
	 <1545315638.4077.5.camel@linux.ibm.com>
	 <CAOQ4uxh=bx_XKjCc88O5+Z_+xJvudp8PgWkaOds1JUEhmKZL3A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <1545323949.4077.36.camel@linux.ibm.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: iforster@suse.de, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, 2018-12-20 at 17:56 +0200, Amir Goldstein wrote:
> On Thu, Dec 20, 2018 at 4:20 PM Mimi Zohar <zohar@linux.ibm.com> wrote:
> >
> > On Thu, 2018-12-20 at 14:04 +0200, Amir Goldstein wrote:
> >
> > > > > 2. What does the call stack look like when failing to verify the hash
> > > > > on oo.text?
> > > >
> > > > *** Cat of same file on merged dir fails (ino != 258)
> > > > cat: overlay/merged/abc.text: Permission denied
> > > >
> > > > [  476.770869] evm: ino: 38593 258 38593 abc.text
> > > > [  476.770876] evm: ino: 38593
> > > > [  476.770883] CPU: 3 PID: 3928 Comm: cat Not tainted 4.20.0-rc2+ #1287
> > > > [  476.770887] Hardware name: LENOVO 20BTS1NJ00/20BTS1NJ00, BIOS N14ET48W (1.26 ) 06/11/2018
> > > > [  476.770890] Call Trace:
> > > > [  476.770906]  dump_stack+0x46/0x5b
> > > > [  476.770913]  hmac_add_misc+0x171/0x180
> > > > [  476.770920]  evm_calc_hmac_or_hash+0x1c9/0x280
> > > > [  476.770927]  evm_verify_hmac+0x11f/0x2b0
> > > > [  476.770933]  ? evm_protected_xattr+0x6c/0x90
> > > > [  476.770940]  ima_appraise_measurement+0x83/0x510
> > > > [  476.770948]  process_measurement+0x646/0x6f0
> > > > [  476.770955]  ? selinux_file_open+0xa8/0xc0
> > > > [  476.770961]  ? do_dentry_open+0x25c/0x340
> > > > [  476.770966]  ? open_with_fake_path+0x48/0x70
> > > > [  476.770974]  ? ovl_open_realfile+0x56/0xe0
> > > > [  476.770981]  ima_file_check+0x4a/0x60
> > >
> > > If you let this check return success even though appraisal failed,
> > > you will see that ovl_open_realfile() will end up calling ima_file_check()
> > > again with the "real" file and this check should not fail.
> > > Hence, my suggestion to mark the overlayfs sb with SB_NOIMA.
> >
> > There's all sorts of caching of results involved in both EVM and IMA.
> > Not so easy to modify.  Assuming that I properly removed the caching,
> >  I'm not seeing another call to ima_file_check.
> >
> 
> Mmm right. open_with_fake_path() doesn't call ima_file_check(). My bad.
> 
> My intuition is that all d_backing_inode() calls under security/integrity
> should be converted to d_real_inode(). After all, users of d_backing_inode()
> probably want the lower/upper inode, because that is what the helper
> claims to do. The reason things worked in v4.18 is because
> d_backing_inode(file_dentry(file)) was the real inode.
> 
> My intuition is that this statement is true for other subsystems that
> use d_backing_inode() as well. We could have changed the
> implementation of d_backing_inode() to call d_real_inode()
> to potentially fix all those subsystems with less churn, but it is hard to
> audit all caller to make sure this is correct for all of them.
> In fact, it is probably not correct for code in fs/*.c.
> 
> So the safer approach is to fix one subsystem at a time by converting
> callers to d_real_inode() and in the end get rid of d_backing_inode().
> 
> Mimi, please try if this fixes EVM over overlayfs.

Yes, changing the hmac_add_misc() call in evm_calc_hmac_or_hash()
fixes the problem.

Mimi

> 
> Miklos, do you have other thoughts about how to address this issue?
> 
> Thanks,
> Amir.
> 
