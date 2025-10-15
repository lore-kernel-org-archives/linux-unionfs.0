Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32729EEDE
	for <linux-unionfs@vger.kernel.org>; Wed, 15 Oct 2025 00:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760486541; cv=none; b=kyLiPrZph9XXI+q3Fk6OFG9UylI28yzHX2A5X2EyJM2dZaSAx65k8KqZMraZiHe9xnfiNVjKGfuCv3/z72oXeavfVTUA8O3Cptf5QgsZg7ZA/93WCj/Iy6fKguzrE2HvUGgwWcjVUT5j3FjNNd00RWiz3s6vQ95UT1wgbJxE3D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760486541; c=relaxed/simple;
	bh=GJVi7Uls4ieWZ3bCIzyejkrCVwWN+vWqRyC0z9mQwkI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r+Zg5sMdHeRKtYZjJ0GuR67/Qjf/JcbXqbAQXyhXGlTdrluntOs7F9f3mzAcGbCnwlEOSq+muYgFdJq+mnU7mSAUC7ToURZk8XxYKikjQklnDC0qiR+y+YHrin8hYzUbA8978pBE9ynCjY0jJzJ5lHAQSGaAmalDUJF7vQjJpG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=eNvsGT62; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="eNvsGT62"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-33b8a8aa73bso1794571a91.0
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Oct 2025 17:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1760486538; x=1761091338; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5lWnsuwkzpeApWk2ViOA5FQ8lFTBV0LeMgWGpahdtj0=;
        b=eNvsGT620FsuqNk3mQttW1M9Tz0dvDGYG3obDZzkYv76UULuvqq6pmbJt41Exq1ftT
         OFaJ2uVM7FVyVg/XqTniQzbXxRyiSGtWfLzLvnpgJ0+srLasKhRVGALb/ADwS9h1kgQC
         Y+wk4C3rPvUA+Fhgzj72jmz8koRmj8xyWnsLYx0bJFJo34+TM5vLziRE7748uIW6KHZh
         pCyiGYaLAgeICDO1ta5v/ivQz5jQbhjmJlSitGwuqfzqpY2ZtXuf8SJlPv8pzehu4pSq
         R9MU4LtWzZGPAajjEYeGZjgYLN9a1yKiExVYHPTj3FJ8ph06LZ6s7DOQEnuFLZv2ThzF
         p3sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760486538; x=1761091338;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5lWnsuwkzpeApWk2ViOA5FQ8lFTBV0LeMgWGpahdtj0=;
        b=g9k/orujYSeQxQunCJMeoTfz+0NWGYGlG0ilqA0ZDU5Wh+HkRxVa6dLe9oYuUM16yM
         0k/8U17UwsA38t3BvGKYsml+RzhXRRpkyl0i+PjIKEWIGHkn+UwQHFVP0dCAXxu4aWbf
         l2OthCRYVT/dzALQQmFVFeR5xebsszToNDcTmAlC+y1oU4QmWQve0F83rkgDJThIaGB/
         uqAVsZBoc5Sglux4iQUvjkUiYeBzgOmnxqJqT6IXUIaD83sfToB5j0bkCG7t+E2MQ8X8
         6hnufUTjJf9adYvWOAhV3LYBvBP2Rg1oWwWtyWs8God+sK8dsjFS/dxNw6ir6n1E58cU
         UC9Q==
X-Forwarded-Encrypted: i=1; AJvYcCXcst/Q6sfTKjPLMtxBvFUFCTsJv+UIrM1d+yoh4TwHN6JkWbPkebVuFHRxjKaSBm9+G9cQffjQ8V6G44Z8@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+o5Z/F60XMZK92OYfs5mhvdlyznTIwBD9bWAVmc573Ws5SOnR
	1vh5HY+/a6CjRZAY7GY4G9RsTrAI5yBeUSI4KID5oxIQuAYm4zvO/tdV685wKQbeQns=
X-Gm-Gg: ASbGncvwE3tcOiCFd1XDpGEH6ATYkvkEQRHdqUXT6hKpUdbrytOlxR+b2LlHvV6lkWS
	iKz/R5Rk1C2jkhPRLeJVb1LpAQlSww043ZA5yWUi1ZCyp/nqhX22Bs9uEnttBj6DIq4xhTntMFI
	fvCzNotcoF9H9885kakJYq+PdmWPRcU2jeH4lL/vk/VJOkEGW1s9Jo1jWCfa56eTTlmenjvUthb
	CLK0lp67Q3IVC4xd/M6saEs5WRJ5Jx6aJMhOjAN11JGUbKM/nEarB6T/TaQYhfGs0lGufcyeJii
	UZKS494PyLkOrl3a7s0MYSj3Ebc4KJoV+pQc6OEVpgIZ5rbLx6Ax1qfzHlzb5tODrofOuF7uHEg
	auxLZQ2ABoEiaGXPJS7KvwI6Jdq4st5jEc7GJKTkIDhxVMtVSawwCBantfKHo6ET4quaOlhgvsQ
	LqxalEuquDvpV52doM
X-Google-Smtp-Source: AGHT+IGoMUjacqS/V8o1WNbZPsHJJvFetdCeeZRacPCwQ/XYo2nNnoscuKOLgAnWu1qaNz9uyKQLiQ==
X-Received: by 2002:a17:90b:4a84:b0:32e:a10b:ce48 with SMTP id 98e67ed59e1d1-33b51114f9emr38707009a91.12.1760486538088;
        Tue, 14 Oct 2025 17:02:18 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b61b11ca9sm17310305a91.24.2025.10.14.17.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 17:02:17 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1v8oy6-0000000EvuK-45Dp;
	Wed, 15 Oct 2025 11:02:14 +1100
Date: Wed, 15 Oct 2025 11:02:14 +1100
From: Dave Chinner <david@fromorbit.com>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Jan Kara <jack@suse.cz>, brauner@kernel.org, viro@zeniv.linux.org.uk,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	josef@toxicpanda.com, kernel-team@fb.com, amir73il@gmail.com,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org,
	linux-unionfs@vger.kernel.org
Subject: Re: [PATCH v7 13/14] xfs: use the new ->i_state accessors
Message-ID: <aO7khoBHdfPlEBAE@dread.disaster.area>
References: <20251009075929.1203950-1-mjguzik@gmail.com>
 <20251009075929.1203950-14-mjguzik@gmail.com>
 <ua3koqbakm6e4dpbzfmhei2evc566c5p2t65nsvmlab5yyibxu@u6zp4pwex5s7>
 <CAGudoHGckJHiWN9yCngP1JMGNa1PPNvnpSuriCxSM1mwWhpBUQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGudoHGckJHiWN9yCngP1JMGNa1PPNvnpSuriCxSM1mwWhpBUQ@mail.gmail.com>

On Fri, Oct 10, 2025 at 05:40:49PM +0200, Mateusz Guzik wrote:
> On Fri, Oct 10, 2025 at 4:41 PM Jan Kara <jack@suse.cz> wrote:
> >
> > On Thu 09-10-25 09:59:27, Mateusz Guzik wrote:
> > > Change generated with coccinelle and fixed up by hand as appropriate.
> > >
> > > Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
> >
> > ...
> >
> > > @@ -2111,7 +2111,7 @@ xfs_rename_alloc_whiteout(
> > >        */
> > >       xfs_setup_iops(tmpfile);
> > >       xfs_finish_inode_setup(tmpfile);
> > > -     VFS_I(tmpfile)->i_state |= I_LINKABLE;
> > > +     inode_state_set_raw(VFS_I(tmpfile), I_LINKABLE);
> > >
> > >       *wip = tmpfile;
> > >       return 0;
> > > @@ -2330,7 +2330,7 @@ xfs_rename(
> > >                * flag from the inode so it doesn't accidentally get misused in
> > >                * future.
> > >                */
> > > -             VFS_I(du_wip.ip)->i_state &= ~I_LINKABLE;
> > > +             inode_state_clear_raw(VFS_I(du_wip.ip), I_LINKABLE);
> > >       }
> > >
> > >  out_commit:
> >
> > These two accesses look fishy (not your fault but when we are doing this
> > i_state exercise better make sure all the places are correct before
> > papering over bugs with _raw function variant). How come they cannot race
> > with other i_state modifications and thus corrupt i_state?
> >
> 
> I asked about this here:
> https://lore.kernel.org/linux-xfs/CAGudoHEi05JGkTQ9PbM20D98S9fv0hTqpWRd5fWjEwkExSiVSw@mail.gmail.com/

Yes, as I said, we can add locking here if necessary, but locking
isn't necessary at this point in time because nothing else can
change the state of the newly allocated whiteout inode until we
unlock it.

Keep in mind the reason why we need I_LINKABLE here - it's not
needed for correctness - it's needed to avoid a warning embedded
in inc_nlink() because filesystems aren't trusted to implement
link counts correctly anymore.

Now we're being told that "it is too dangerous to let filesystems
manage inode state themselves" and so we have to add extra overhead
to code that we were forced to add to avoid VFS warnings added
because the VFS doesn't trust filesystems to maintain some other
important inode state....

So, if you want to get rid of XFS using I_LINKABLE here, please fix
the nlink VFS api to allow us to call inc_nlink_<something>() on a
zero link inode without I_LINKABLE needing to be set. We do actually
know what we are doing here, and as such needing I_LINKABLE here is
nothing but a hacky workaround for inflexible, trustless VFS APIs...

> > > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > > index caff0125faea..ad94fbf55014 100644
> > > --- a/fs/xfs/xfs_iops.c
> > > +++ b/fs/xfs/xfs_iops.c
> > > @@ -1420,7 +1420,7 @@ xfs_setup_inode(
> > >       bool                    is_meta = xfs_is_internal_inode(ip);
> > >
> > >       inode->i_ino = ip->i_ino;
> > > -     inode->i_state |= I_NEW;
> > > +     inode_state_set_raw(inode, I_NEW);

"set" is wrong and will introduce a regression. This must be an
"add" operation as inode->i_state may have already been modified
by the time we get here. From 2021:

commit f38a032b165d812b0ba8378a5cd237c0888ff65f
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Aug 24 19:13:04 2021 -0700

    xfs: fix I_DONTCACHE

    Yup, the VFS hoist broke it, and nobody noticed. Bulkstat workloads
    make it clear that it doesn't work as it should.

    Fixes: dae2f8ed7992 ("fs: Lift XFS_IDONTCACHE to the VFS layer")
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Darrick J. Wong <djwong@kernel.org>
    Signed-off-by: Darrick J. Wong <djwong@kernel.org>

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index a3fe4c5307d3..f2210d927481 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -84,8 +84,9 @@ xfs_inode_alloc(
                return NULL;
        }

-       /* VFS doesn't initialise i_mode! */
+       /* VFS doesn't initialise i_mode or i_state! */
        VFS_I(ip)->i_mode = 0;
+       VFS_I(ip)->i_state = 0;

        XFS_STATS_INC(mp, vn_active);
        ASSERT(atomic_read(&ip->i_pincount) == 0);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 0ff0cca94092..a607d6aca5c4 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1344,7 +1344,7 @@ xfs_setup_inode(
        gfp_t                   gfp_mask;

        inode->i_ino = ip->i_ino;
-       inode->i_state = I_NEW;
+       inode->i_state |= I_NEW;

        inode_sb_list_add(inode);
        /* make the inode look hashed for the writeback code */

-Dave.
-- 
Dave Chinner
david@fromorbit.com
