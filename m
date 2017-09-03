From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH V4] overlay: Test constant d_ino feature
Date: Sun, 03 Sep 2017 18:28:04 +0530
Message-ID: <42988594.zmNOMRAluC@localhost.localdomain>
References: <20170903084002.1900-1-chandan@linux.vnet.ibm.com> <CAOQ4uxgy7CJeFZkbdqes8+3J0he9mX=BEkG5gFO_gcEWcj8UJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36623 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751611AbdICM51 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 3 Sep 2017 08:57:27 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v83CsZuh075308
        for <linux-unionfs@vger.kernel.org>; Sun, 3 Sep 2017 08:57:27 -0400
Received: from e23smtp04.au.ibm.com (e23smtp04.au.ibm.com [202.81.31.146])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2cqrqxswph-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Sun, 03 Sep 2017 08:57:26 -0400
Received: from localhost
        by e23smtp04.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Sun, 3 Sep 2017 22:57:24 +1000
In-Reply-To: <CAOQ4uxgy7CJeFZkbdqes8+3J0he9mX=BEkG5gFO_gcEWcj8UJQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

On Sunday, September 3, 2017 3:32:11 PM IST Amir Goldstein wrote:
> On Sun, Sep 3, 2017 at 11:40 AM, Chandan Rajendra
> <chandan@linux.vnet.ibm.com> wrote:
> > This commit adds a test to verify constant d_ino feature. The following
> > scenarios are checked,
> > - Parent's (i.e. "..") d_ino must always be calculated because a pure
> >   dir can be residing inside a merged dir.
> > - d_ino for "." must always be calculated because the present directory
> >   can have a copy-up origin.
> > - Verify d_ino of '.' and '..' before and after dir becomes
> >   impure. While at it also verify if trusted.overlay.impure xattr is
> >   set/reset appropriately and invalidation of readdir cache.
> > - Verify copied up file's (inside a impure dir) d_ino.
> > - Verify d_ino values corresponding to "." and ".." entries of a pure
> >   lower dir.
> > - Verify d_ino of ".." entry of a merged dir.
> > - Verify pure lower residing in dir which has another lower layer
> >
> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> > ---
> > Changelog:
> > v3->v4:
> > 1. Fix error handling as suggested by Amir.
> > 2. Use sane variable names for "Verify pure lower residing in dir which has
> >    another lower layer" test.
> >
> ...
> > +# Verify invalidation of readdir cache
> > +$here/src/t_dir_type $impure_dir $test_file_st_ino
> > +[[ $? != 0 ]] || echo "Directory's readdir cache has stale entries"
> > +
> > +$GETFATTR_PROG --absolute-names -n 'trusted.overlay.impure' \
> > +              $upperdir/test_dir/impure_dir >>$seqres.full 2>&1
> > +[[ $? == 0 ]] && echo "Pure directory has impure xattr"
> > +
> 
> Sorry, I overlooked a few things in v3:
> 1. Why did  I say use && echo here I'm not sure. looking again feels
>     much better to conform to all other tests

Right. I will fix it up.

> 2. I wanted to write and forgot that you need _require_attrs and
> include common/attr

I will add these lines.

> 3. This test is using double brackets [[ == comparison all around,
> which apparently
>     saves the need to surround left side in quotes "". This seems to
> be recommended
>     so I have no objection. Just pointing out to Eryu in case he has
> reservations.

-- 
chandan
