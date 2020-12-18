Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FB8FC4361B
	for <linux-unionfs@archiver.kernel.org>; Fri, 18 Dec 2020 07:02:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5752D23118
	for <linux-unionfs@archiver.kernel.org>; Fri, 18 Dec 2020 07:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725894AbgLRHC7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 18 Dec 2020 02:02:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbgLRHC6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 18 Dec 2020 02:02:58 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93045C0617A7;
        Thu, 17 Dec 2020 23:02:18 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id 75so1208211ilv.13;
        Thu, 17 Dec 2020 23:02:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nNA3gIrKHh9x8sDKplgxIB2z13v0h/7Qfqc7WMGts5E=;
        b=AWA20ztU77fNmUet/InrjHBWCBQVqeiWzFGt5iInqGf7plQ5MBvR2WJ4TpSSy8SAPJ
         nKwp+dUOf9seuC5MEm34PhKEke9oAToCSdyrm0jZjC2X05RENJmIYN4tMeV8kor5R0wK
         KSH5s1e6MJwHXs4Oll5hBLrBhP3xTshj3JRFL+HPc0xLdDLsNWdC/gjNyfyarGWZKdGU
         GawIhB2Mw6FTlewiGXUGMiKCbGKqLkkFexTzYwW28LhnDg0tH7QuzohmPJbxwf3hQ8HM
         +RPQdzsHwdjKRuVqqQ8/tyKejgUj11+XPqT+6Xjisj2WUrdLFs9nfsOqxkbxMkzreVS6
         5wVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nNA3gIrKHh9x8sDKplgxIB2z13v0h/7Qfqc7WMGts5E=;
        b=jkidk5Quwv0vz5ZVY3Zm5Bdp+L40dWLjLkgnA4BeJ43clPShuorIx3fkGFlLkPk/N1
         ugn8MVWdGni2Bum/efdICLn0YKU182QfoSnar2TUwNuyDDTJ6hmNFCWMLNJat1wYvMeK
         zueQTTxmz9hSx+x2MvNvJSAkjExGce5TVZs782+JAPRkYk3RGDQ2himyHxS5KziUdOS4
         36um3mYr46FKaq1lKwKMSQ3aqmgDqYbpjFQOUbC8kSnAd8Oey8HpT2eZNSwB1W33AyLT
         8cZOuC4TWp2w3+fDa1EqNysrvSLJpFjD03GpT06EizBkNaP+sQlB9+X7CcBFf48yp3YO
         6YEQ==
X-Gm-Message-State: AOAM530KojGOt6tqeh3g9izFlVJEU+JnCEBKcF+SrQeu7yO565N2TMKi
        6LRqkwO9ZNdPu8FID6dx1F8Z+xVGe+dGDKriI0o=
X-Google-Smtp-Source: ABdhPJykBJejFkn9EteVOLWfluyZLYMNWKO94GlkEam90SosvpEYyooqKprqzIZPo2BK8mHiKWaCe2uWTqF1QjKFdsM=
X-Received: by 2002:a05:6e02:60f:: with SMTP id t15mr2502684ils.250.1608274937791;
 Thu, 17 Dec 2020 23:02:17 -0800 (PST)
MIME-Version: 1.0
References: <2nv9d47zt7.fsf@aldarion.sourceruckus.org> <2n1rfrf5l0.fsf@aldarion.sourceruckus.org>
 <CAOQ4uxg4hmtGXg6dNghjfVpfiJFj6nauzqTgZucwSJAJq1Z3Eg@mail.gmail.com>
 <CAOQxz3wW8QF-+HFL1gcgH+nVvySN3fogop0v+KNcxpbzu9BkJA@mail.gmail.com>
 <CAOQ4uxgsFnkUqnXYyMNdZU=s_Wq18fdbr0ZhepNLMYh9MfPe9w@mail.gmail.com>
 <CAOQxz3wUvi_O7hzNrN8oTGfnFz-PiVr3Z6nG1ZXLFjpnH4q81g@mail.gmail.com>
 <CAOQxz3zGaKnJCUe7DuegOqbbPAvNj8hTFA6_LsGEPTMXwUpn6g@mail.gmail.com>
 <CAOQ4uxifSf-q1fXC_zxOpqR8GDX8sr2CWPsXrJ6e0YSrfB6v8Q@mail.gmail.com>
 <CAOQxz3xZWCdF=7AZ=N0ajcN8FVjzU2sS_SpxzwRFyHGvwc7dZA@mail.gmail.com>
 <CAOQ4uxjmUY+N6sBoD-d2MN4eehPCcWzBXTHkDqAcCVtkpbG2kw@mail.gmail.com>
 <CAOQxz3y8N6ny23iA1Fe0L4M1gR=FHP5xANZXquu4NSLoucorKw@mail.gmail.com>
 <CAOQ4uxg++DkgcO9K6wkSn0p6QvvkwK0nvxBzSpNE6RdaCH3aQg@mail.gmail.com>
 <CAOQxz3wbqnUxSL-Ks=7USUZU1+04Uvqi-FnTZFGRL9uqQvvNfA@mail.gmail.com> <CAOQxz3xNWoj5Az-0JAk1Ay3T_QyE1bso7pxC_7n=hV3B5PBK0w@mail.gmail.com>
In-Reply-To: <CAOQxz3xNWoj5Az-0JAk1Ay3T_QyE1bso7pxC_7n=hV3B5PBK0w@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 18 Dec 2020 09:02:06 +0200
Message-ID: <CAOQ4uxjw5AroFpYBkGExiAfHir4OyABk023RQK_s6TPQ5aTJCw@mail.gmail.com>
Subject: Re: failed open: No data available
To:     Michael Labriola <michael.d.labriola@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        LSM List <linux-security-module@vger.kernel.org>,
        Jonathan Lebon <jlebon@redhat.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000005ec1e905b6b7b076"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

--0000000000005ec1e905b6b7b076
Content-Type: text/plain; charset="UTF-8"

On Fri, Dec 18, 2020 at 1:47 AM Michael Labriola
<michael.d.labriola@gmail.com> wrote:
>
> On Thu, Dec 17, 2020 at 4:56 PM Michael Labriola
> <michael.d.labriola@gmail.com> wrote:
> >
> > On Thu, Dec 17, 2020 at 3:25 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > On Thu, Dec 17, 2020 at 9:46 PM Michael Labriola
> > > <michael.d.labriola@gmail.com> wrote:
> > > >
> > > > On Thu, Dec 17, 2020 at 1:07 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > > > >
> > > > > On Thu, Dec 17, 2020 at 6:22 PM Michael Labriola
> > > > *snip*
> > > > > > On Thu, Dec 17, 2020 at 7:00 AM Amir Goldstein <amir73il@gmail.com> wrote:
> > > > > > Thanks, Amir.  I didn't have CONFIG_DYNAMIC_DEBUG enabled, so
> > > > >
> > > > > I honestly don't expect to find much in the existing overlay debug prints
> > > > > but you never know..
> > > > > I suspect you will have to add debug prints to find the problem.
> > > >
> > > > Ok, here goes.  I had to setup a new virtual machine that doesn't use
> > > > overlayfs for its root filesystem because turning on dynamic debug
> > > > gave way too much output for a nice controlled test.  It's exhibiting
> > > > the same behavior as my previous tests (5.8 good, 5.9 bad).  The is
> > > > with a freshly compiled 5.9.15 w/ CONFIG_OVERLAY_FS_XINO_AUTO turned
> > > > off and CONFIG_DYNAMIC_DEBUG turned on.  Here's what we get:
> > > >
> > > >  echo "file fs/overlayfs/*  +p" > /sys/kernel/debug/dynamic_debug/control
> > > >  mount borky2.sqsh t
> > > >  mount -t tmpfs tmp tt
> > > >  mkdir -p tt/upper/{upper,work}
> > > >  mount -t overlay -o \
> > > >     lowerdir=t,upperdir=tt/upper/upper,workdir=tt/upper/work blarg ttt
> > > > [  164.505193] overlayfs: mkdir(work/work, 040000) = 0
> > > > [  164.505204] overlayfs: tmpfile(work/work, 0100000) = 0
> > > > [  164.505209] overlayfs: create(work/#3, 0100000) = 0
> > > > [  164.505210] overlayfs: rename(work/#3, work/#4, 0x4)
> > > > [  164.505216] overlayfs: unlink(work/#3) = 0
> > > > [  164.505217] overlayfs: unlink(work/#4) = 0
> > > > [  164.505221] overlayfs: setxattr(work/work,
> > > > "trusted.overlay.opaque", "0", 1, 0x0) = 0
> > > >
> > > >  touch ttt/FOO
> > > > touch: cannot touch 'ttt/FOO': No data available
> > > > [  191.919498] overlayfs: setxattr(upper/upper,
> > > > "trusted.overlay.impure", "y", 1, 0x0) = 0
> > > > [  191.919523] overlayfs: tmpfile(work/work, 0100644) = 0
> > > > [  191.919788] overlayfs: tmpfile(work/work, 0100644) = 0
> > > >
> > > > That give you any hints?  I'll start reading through the overlayfs
> > > > code.  I've never actually looked at it, so I'll be planting printk
> > > > calls at random.  ;-)
> > >
> > > We have seen that open("FOO", O_WRONLY) fails
> > > We know that FOO is lower at that time so that brings us to
> > >
> > > ovl_open
> > >   ovl_maybe_copy_up
> > >     ovl_copy_up_flags
> > >       ovl_copy_up_one
> > >         ovl_do_copy_up
> > >           ovl_set_impure
> > > [  191.919498] overlayfs: setxattr(upper/upper,
> > > "trusted.overlay.impure", "y", 1, 0x0) = 0
> > >           ovl_copy_up_tmpfile
> > >             ovl_do_tmpfile
> > > [  191.919523] overlayfs: tmpfile(work/work, 0100644) = 0
> > >             ovl_copy_up_inode
> > > This must be were we fail and likely in:
> > >               ovl_copy_xattr
> > >                  vfs_getxattr
> > > which can return -ENODATA, but it is not expected because the
> > > xattrs returned by vfs_listxattr should exist...
> > >
> > > So first guess would be to add a debug print for xattr 'name'
> > > and return value of vfs_getxattr().
> >
> > Ok, here we go.  I've added a bunch of printks all over the place.
> > Here's what we've got.  Things are unchanged during mount.  Trying to
> > touch FOO now gives me this:
> >
> > [  114.365444] ovl_open: start
> > [  114.365450] ovl_maybe_copy_up: start
> > [  114.365452] ovl_maybe_copy_up: need copy up
> > [  114.365454] ovl_maybe_copy_up: ovl_want_write succeeded
> > [  114.365459] ovl_copy_up_one: calling ovl_do_copy_up()
> > [  114.365460] ovl_do_copy_up: start
> > [  114.365462] ovl_do_copy_up: impure
> > [  114.365464] ovl_set_impure: start
> > [  114.365484] overlayfs: setxattr(upper/upper,
> > "trusted.overlay.impure", "y", 1, 0x0) = 0
> > [  114.365486] ovl_copy_up_tmpfile: start
> > [  114.365507] overlayfs: tmpfile(work/work, 0100644) = 0
> > [  114.365510] ovl_copy_up_inode: start
> > [  114.365511] ovl_copy_up_inode: ISREG && !metacopy
> > [  114.365625] ovl_copy_xattr: start
> > [  114.365630] ovl_copy_xattr: vfs_listxattr() returned 17
> > [  114.365632] ovl_copy_xattr: buf allocated good
> > [  114.365634] ovl_copy_xattr: vfs_listxattr() returned 17
> > [  114.365636] ovl_copy_xattr: slen=17
> > [  114.365638] ovl_copy_xattr: name='security.selinux'
>
> SELinux?  now that's not suspicious at all...
>
> > [  114.365643] ovl_copy_xattr: vfs_getxattr returned size=-61
> > [  114.365644] ovl_copy_xattr: cleaning up
> > [  114.365647] ovl_copy_up_inode: ovl_copy_xattr error=-61
> > [  114.365649] ovl_copy_up_one: error=-61
> > [  114.365651] ovl_copy_up_one: calling ovl_copy_up_end()
> > [  114.365653] ovl_copy_up_flags: ovl_copy_up_one error=-61
> > [  114.365655] ovl_maybe_copy_up: ovl_copy_up_flags error=-61
> > [  114.365658] ovl_open: ovl_maybe_copy_up error=-61
> > [  114.365728] ovl_copy_up_one: calling ovl_do_copy_up()
> > [  114.365730] ovl_do_copy_up: start
> > [  114.365731] ovl_do_copy_up: impure
> > [  114.365733] ovl_set_impure: start
> > [  114.365735] ovl_copy_up_tmpfile: start
> > [  114.365748] overlayfs: tmpfile(work/work, 0100644) = 0
> > [  114.365750] ovl_copy_up_inode: start
> > [  114.365752] ovl_copy_up_inode: ISREG && !metacopy
> > [  114.365770] ovl_copy_xattr: start
> > [  114.365773] ovl_copy_xattr: vfs_listxattr() returned 17
> > [  114.365774] ovl_copy_xattr: buf allocated good
> > [  114.365776] ovl_copy_xattr: vfs_listxattr() returned 17
> > [  114.365778] ovl_copy_xattr: slen=17
> > [  114.365780] ovl_copy_xattr: name='security.selinux'
> > [  114.365784] ovl_copy_xattr: vfs_getxattr returned size=-61
> > [  114.365785] ovl_copy_xattr: cleaning up
> > [  114.365787] ovl_copy_up_inode: ovl_copy_xattr error=-61
> > [  114.365789] ovl_copy_up_one: error=-61
> > [  114.365790] ovl_copy_up_one: calling ovl_copy_up_end()
> > [  114.365792] ovl_copy_up_flags: ovl_copy_up_one error=-61
> >
> *snip*
>
> So, the selinux stuff made me raise an eyebrow...  I've got selinux
> enabled in my kernel so that it's there if I boot up a RHEL box with
> this kernel.  But I'm using Ubuntu right now, and the rest of SELinux
> is not installed/enabled.  There shouldn't be any selinux labels in
> the files I slurped up into my squashfs image, so there shouldn't be
> any in the squashfs, so of course that won't work.
>
> I tried compiling CONFIG_SELINUX=n and guess what, it works now.  So
> that's at least a work-around for me.
>
> So, for whatever reason, between 5.8 and 5.9, having CONFIG_SELINUX=y
> but no security labels on the filesystem became a problem?  Is this
> something that needs to get fixed in overlayfs?  Or do you think it's
> a deeper problem that needs fixing elsewhere?
>

It's both :)

Attached two patches that should each fix the issue independently,
but we need to apply both. I only tested that they build.
Please verify that each applied individually solves the problem.

The selinux- patch fixes an selinux regression introduced in kernel v5.9
the regression is manifested in your test case but goes beyond overlayfs.

The ovl- patch is a workaround for the selinux regression, but it is also
a micro optimization that doesn't hurt, so worth applying it anyway.

Thanks,
Amir.

--0000000000005ec1e905b6b7b076
Content-Type: text/plain; charset="US-ASCII"; 
	name="selinux-fix-inconsistency-between-inode_getxattr-and.patch.txt"
Content-Disposition: attachment; 
	filename="selinux-fix-inconsistency-between-inode_getxattr-and.patch.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_kitwa7o40>
X-Attachment-Id: f_kitwa7o40

RnJvbSA3YmI1NGMxY2UxMDZkZTI2YTFmNTJiZDkwZGMzNDY0ZmYxZmI0MjY5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwuY29tPgpE
YXRlOiBGcmksIDE4IERlYyAyMDIwIDA3OjQxOjIxICswMjAwClN1YmplY3Q6IFtQQVRDSF0gc2Vs
aW51eDogZml4IGluY29uc2lzdGVuY3kgYmV0d2VlbiBpbm9kZV9nZXR4YXR0ciBhbmQKIGlub2Rl
X2xpc3RzZWN1cml0eQoKV2hlbiBpbm9kZSBoYXMgbm8gbGlzdHhhdHRyIG9wIG9mIGl0cyBvd24g
KGUuZy4gc3F1YXNoZnMpIHZmc19saXN0eGF0dHIKY2FsbHMgdGhlIExTTSBpbm9kZV9saXN0c2Vj
dXJpdHkgaG9va3MgdG8gbGlzdCB0aGUgeGF0dHJzIHRoYXQgTFNNcyB3aWxsCmludGVyY2VwdCBp
biBpbm9kZV9nZXR4YXR0ciBob29rcy4KCldoZW4gc2VsaW51eCBMU00gaXMgaW5zdGFsbGVkIGJ1
dCBub3QgaW5pdGlhbGl6ZWQsIGl0IHdpbGwgbGlzdCB0aGUKc2VjdXJpdHkuc2VsaW51eCB4YXR0
ciBpbiBpbm9kZV9saXN0c2VjdXJpdHksIGJ1dCB3aWxsIG5vdCBpbnRlcmNlcHQgaXQKaW4gaW5v
ZGVfZ2V0eGF0dHIuICBUaGlzIHJlc3VsdHMgaW4gLUVOT0RBVEEgZm9yIGEgZ2V0eGF0dHIgY2Fs
bCBmb3IgYW4KeGF0dHIgcmV0dXJuZWQgYnkgbGlzdHhhdHRyLgoKVGhpcyBzaXR1YXRpb24gd2Fz
IG1hbmlmZXN0ZWQgYXMgb3ZlcmxheWZzIGZhaWx1cmUgdG8gY29weSB1cCBsb3dlcgpmaWxlcyBm
cm9tIHNxdWFzaGZzIHdoZW4gc2VsaW51eCBpcyBidWlsdC1pbiBidXQgbm90IGluaXRpYWxpemVk
LApiZWNhdXNlIG92bF9jb3B5X3hhdHRyKCkgaXRlcmF0ZXMgdGhlIGxvd2VyIGlub2RlIHhhdHRy
cyBieQp2ZnNfbGlzdHhhdHRyKCkgYW5kIHZmc19nZXR4YXR0cigpLgoKTWF0Y2ggdGhlIGxvZ2lj
IG9mIGlub2RlX2xpc3RzZWN1cml0eSB0byB0aGF0IG9mIGlub2RlX2dldHhhdHRyIGFuZApkbyBu
b3QgbGlzdCB0aGUgc2VjdXJpdHkuc2VsaW51eCB4YXR0ciBpZiBzZWxpbnV4IGlzIG5vdCBpbml0
aWFsaXplZC4KClJlcG9ydGVkLWJ5OiBNaWNoYWVsIExhYnJpb2xhIDxtaWNoYWVsLmQubGFicmlv
bGFAZ21haWwuY29tPgpGaXhlczogYzhlMjIyNjE2YzdlICgic2VsaW51eDogYWxsb3cgcmVhZGlu
ZyBsYWJlbHMgYmVmb3JlIHBvbGljeSBpcyBsb2FkZWQiKQpDYzogc3RhYmxlQHZnZXIua2VybmVs
Lm9yZyN2NS45KwpTaWduZWQtb2ZmLWJ5OiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwu
Y29tPgotLS0KIHNlY3VyaXR5L3NlbGludXgvaG9va3MuYyB8IDQgKysrKwogMSBmaWxlIGNoYW5n
ZWQsIDQgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL3NlY3VyaXR5L3NlbGludXgvaG9va3Mu
YyBiL3NlY3VyaXR5L3NlbGludXgvaG9va3MuYwppbmRleCA2YjE4MjZmYzM2NTguLmUxMzJlMDgy
YTVhZiAxMDA2NDQKLS0tIGEvc2VjdXJpdHkvc2VsaW51eC9ob29rcy5jCisrKyBiL3NlY3VyaXR5
L3NlbGludXgvaG9va3MuYwpAQCAtMzQwNiw2ICszNDA2LDEwIEBAIHN0YXRpYyBpbnQgc2VsaW51
eF9pbm9kZV9zZXRzZWN1cml0eShzdHJ1Y3QgaW5vZGUgKmlub2RlLCBjb25zdCBjaGFyICpuYW1l
LAogc3RhdGljIGludCBzZWxpbnV4X2lub2RlX2xpc3RzZWN1cml0eShzdHJ1Y3QgaW5vZGUgKmlu
b2RlLCBjaGFyICpidWZmZXIsIHNpemVfdCBidWZmZXJfc2l6ZSkKIHsKIAljb25zdCBpbnQgbGVu
ID0gc2l6ZW9mKFhBVFRSX05BTUVfU0VMSU5VWCk7CisKKwlpZiAoIXNlbGludXhfaW5pdGlhbGl6
ZWQoJnNlbGludXhfc3RhdGUpKQorCQlyZXR1cm4gMDsKKwogCWlmIChidWZmZXIgJiYgbGVuIDw9
IGJ1ZmZlcl9zaXplKQogCQltZW1jcHkoYnVmZmVyLCBYQVRUUl9OQU1FX1NFTElOVVgsIGxlbik7
CiAJcmV0dXJuIGxlbjsKLS0gCjIuMjUuMQoK
--0000000000005ec1e905b6b7b076
Content-Type: text/plain; charset="US-ASCII"; 
	name="ovl-skip-getxattr-of-security-labels.patch.txt"
Content-Disposition: attachment; 
	filename="ovl-skip-getxattr-of-security-labels.patch.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_kitwa7ob1>
X-Attachment-Id: f_kitwa7ob1

RnJvbSBmMzEwOTc5MTRmYzQ5MzM3M2MzYmMyYzM0NGE3MGU5MDU3OTExNDQyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwuY29tPgpE
YXRlOiBGcmksIDE4IERlYyAyMDIwIDA3OjQxOjIxICswMjAwClN1YmplY3Q6IFtQQVRDSF0gb3Zs
OiBza2lwIGdldHhhdHRyIG9mIHNlY3VyaXR5IGxhYmVscwoKV2hlbiBpbm9kZSBoYXMgbm8gbGlz
dHhhdHRyIG9wIG9mIGl0cyBvd24gKGUuZy4gc3F1YXNoZnMpIHZmc19saXN0eGF0dHIKY2FsbHMg
dGhlIExTTSBpbm9kZV9saXN0c2VjdXJpdHkgaG9va3MgdG8gbGlzdCB0aGUgeGF0dHJzIHRoYXQg
TFNNcyB3aWxsCmludGVyY2VwdCBpbiBpbm9kZV9nZXR4YXR0ciBob29rcy4KCldoZW4gc2VsaW51
eCBMU00gaXMgaW5zdGFsbGVkIGJ1dCBub3QgaW5pdGlhbGl6ZWQsIGl0IHdpbGwgbGlzdCB0aGUK
c2VjdXJpdHkuc2VsaW51eCB4YXR0ciBpbiBpbm9kZV9saXN0c2VjdXJpdHksIGJ1dCB3aWxsIG5v
dCBpbnRlcmNlcHQgaXQKaW4gaW5vZGVfZ2V0eGF0dHIuICBUaGlzIHJlc3VsdHMgaW4gLUVOT0RB
VEEgZm9yIGEgZ2V0eGF0dHIgY2FsbCBmb3IgYW4KeGF0dHIgcmV0dXJuZWQgYnkgbGlzdHhhdHRy
LgoKVGhpcyBzaXR1YXRpb24gd2FzIG1hbmlmZXN0ZWQgYXMgb3ZlcmxheWZzIGZhaWx1cmUgdG8g
Y29weSB1cCBsb3dlcgpmaWxlcyBmcm9tIHNxdWFzaGZzIHdoZW4gc2VsaW51eCBpcyBidWlsdC1p
biBidXQgbm90IGluaXRpYWxpemVkLApiZWNhdXNlIG92bF9jb3B5X3hhdHRyKCkgaXRlcmF0ZXMg
dGhlIGxvd2VyIGlub2RlIHhhdHRycyBieQp2ZnNfbGlzdHhhdHRyKCkgYW5kIHZmc19nZXR4YXR0
cigpLgoKb3ZsX2NvcHlfeGF0dHIoKSBza2lwcyBjb3B5IHVwIG9mIHNlY3VyaXR5IGxhYmVscyB0
aGF0IGFyZSBpbmRlbnRpZmllZCBieQppbm9kZV9jb3B5X3VwX3hhdHRyIExTTSBob29rcywgYnV0
IGl0IGRvZXMgdGhhdCBhZnRlciB2ZnNfZ2V0eGF0dHIoKS4KU2luY2Ugd2UgYXJlIG5vdCBnb2lu
ZyB0byBjb3B5IHRoZW0sIHNraXAgdmZzX2dldHhhdHRyKCkgb2YgdGhlIHNlY3VyaXR5CmxhYmVs
cy4KClJlcG9ydGVkLWJ5OiBNaWNoYWVsIExhYnJpb2xhIDxtaWNoYWVsLmQubGFicmlvbGFAZ21h
aWwuY29tPgpGaXhlczogYzhlMjIyNjE2YzdlICgic2VsaW51eDogYWxsb3cgcmVhZGluZyBsYWJl
bHMgYmVmb3JlIHBvbGljeSBpcyBsb2FkZWQiKQpDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZyN2
NS45KwpTaWduZWQtb2ZmLWJ5OiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwuY29tPgot
LS0KIGZzL292ZXJsYXlmcy9jb3B5X3VwLmMgfCAxNSArKysrKysrKy0tLS0tLS0KIDEgZmlsZSBj
aGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMv
b3ZlcmxheWZzL2NvcHlfdXAuYyBiL2ZzL292ZXJsYXlmcy9jb3B5X3VwLmMKaW5kZXggZTViNjE2
YzkzZTExLi4wZmVkNTMyZWZhNjggMTAwNjQ0Ci0tLSBhL2ZzL292ZXJsYXlmcy9jb3B5X3VwLmMK
KysrIGIvZnMvb3ZlcmxheWZzL2NvcHlfdXAuYwpAQCAtODQsNiArODQsMTQgQEAgaW50IG92bF9j
b3B5X3hhdHRyKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsIHN0cnVjdCBkZW50cnkgKm9sZCwKIAog
CQlpZiAob3ZsX2lzX3ByaXZhdGVfeGF0dHIoc2IsIG5hbWUpKQogCQkJY29udGludWU7CisKKwkJ
ZXJyb3IgPSBzZWN1cml0eV9pbm9kZV9jb3B5X3VwX3hhdHRyKG5hbWUpOworCQlpZiAoZXJyb3Ig
PCAwICYmIGVycm9yICE9IC1FT1BOT1RTVVBQKQorCQkJYnJlYWs7CisJCWlmIChlcnJvciA9PSAx
KSB7CisJCQllcnJvciA9IDA7CisJCQljb250aW51ZTsgLyogRGlzY2FyZCAqLworCQl9CiByZXRy
eToKIAkJc2l6ZSA9IHZmc19nZXR4YXR0cihvbGQsIG5hbWUsIHZhbHVlLCB2YWx1ZV9zaXplKTsK
IAkJaWYgKHNpemUgPT0gLUVSQU5HRSkKQEAgLTEwNywxMyArMTE1LDYgQEAgaW50IG92bF9jb3B5
X3hhdHRyKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsIHN0cnVjdCBkZW50cnkgKm9sZCwKIAkJCWdv
dG8gcmV0cnk7CiAJCX0KIAotCQllcnJvciA9IHNlY3VyaXR5X2lub2RlX2NvcHlfdXBfeGF0dHIo
bmFtZSk7Ci0JCWlmIChlcnJvciA8IDAgJiYgZXJyb3IgIT0gLUVPUE5PVFNVUFApCi0JCQlicmVh
azsKLQkJaWYgKGVycm9yID09IDEpIHsKLQkJCWVycm9yID0gMDsKLQkJCWNvbnRpbnVlOyAvKiBE
aXNjYXJkICovCi0JCX0KIAkJZXJyb3IgPSB2ZnNfc2V0eGF0dHIobmV3LCBuYW1lLCB2YWx1ZSwg
c2l6ZSwgMCk7CiAJCWlmIChlcnJvcikgewogCQkJaWYgKGVycm9yICE9IC1FT1BOT1RTVVBQIHx8
IG92bF9tdXN0X2NvcHlfeGF0dHIobmFtZSkpCi0tIAoyLjI1LjEKCg==
--0000000000005ec1e905b6b7b076--
