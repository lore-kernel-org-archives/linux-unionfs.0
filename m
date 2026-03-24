Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C783659E7
	for <linux-unionfs@vger.kernel.org>; Tue, 24 Mar 2026 08:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774340912; cv=pass; b=u/y7fMmVaVefnt8Xt6ZeRFpbUfAPSpOAgt5wbOdHxuQhSDRFEn20b3+/47Cb3n8T+BcY/GYjVSmk+ADF6yUty9C9O/CY7s998VzKyF6vp6XkL3iAqLEezBgpqvgxZw3ITB7A9PcoVuWgoWud2NrX3pZ9NryAtPV7GI5Y+xYQd3o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774340912; c=relaxed/simple;
	bh=tyQeomo4l0e4WGPfMZjOg8hL7A52QCZZza6GeOK/YyY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j0d+6naBYSeidP+xfgIXFDGIoBGlBtVtbY+6ve4bprbF/N0nvqTFxKFDRS2Wm66swqaUxSL6ixftF/hwn9BGQY0DZ7ji7HLrKTpHaY4VNCTM/keXpgUJIzH2ajC5wp5JDF0Kp1197Xp0SrbkwsLrjrsCAWGe7iLhxTZENk0ylq8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OjsFtJEY; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OjsFtJEY"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-509062d829dso386101cf.1
        for <linux-unionfs@vger.kernel.org>; Tue, 24 Mar 2026 01:28:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774340903; cv=none;
        d=google.com; s=arc-20240605;
        b=JVTumWNHus9F24VrDOdy8FFA8K/QZAHekZeX3VVpmzGOq7wBZrq0xdl2pt0Ojtv8gc
         7UNhxJzZdI/M6AWPyrGupALH7rtyHJnDZiTfjT1a46ldrt5NPbdjMGif6HzcG+yor5rX
         3pK6frd05gKP0iMoRCUJcBlQQsiULuWK6YL4w/FnesaqsE9F30StmUeTQTmxmZCCggDW
         N/1ive0t2lyx/zftsMmhRVdz9HGkbCVqDESf3CI4h1hBjRqxb/w+ZDCytj5/Ut+si+nl
         AUkSvCpRog9ksrYtYomo2tTzN+6fCSdhBta+WhYs+FPN8XNQg7sfwmI3f0dBSvFskJ+d
         Pcxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=k/R4UrJ3i0AKSFB8S0BGmvzRVh7LGwkVlhjThqkyhKg=;
        fh=0PKR6hjWLKhftCcJ37qUpfe72/vhBUt2DK3sXKJxQHE=;
        b=FG1Fr7CJzAfIfNz9y1na3yBDqIJrQq+R3x56gVv2RULWYUmW6f6MzibAoWsyDp6GHx
         /Jea9/mtJ5BGfdcyJ03aiUb0riPSf5kZ1jXyk+pwdXO0skPElf2p84IjqvFux9VzPSwa
         JMHPV7vayk1l6AH3MtSrtc9IIClpaJkjxvstIyrZGddgG+2LFan9HZcKFFLElqu4uRyR
         ukcu9Tl94YYF80Yrf4DHeeyPuLPbQ4i6xL15lvZY1bJK7KLxyDNuxBWWnwuaIFbx7E23
         q4UkMHzTnQkXZE6Wgi8IsmHKaimoTA/WuDuBXmwYhOeS80nznglI9BKHvk8OdUKy/Ake
         YhPA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774340903; x=1774945703; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k/R4UrJ3i0AKSFB8S0BGmvzRVh7LGwkVlhjThqkyhKg=;
        b=OjsFtJEYLVlV7FadTD+YZUVrv7DIm4H2oto3/P+FFWHOZDyrhaPUDUqJEzMUKeVgdg
         NgnMngBUi5V92KAM6S2CFLQB4Yl9j2cEdwhKggutiMHzq+HHMY8W9XV3rO/Xkkgcb/5e
         7Lbualiwe4Qjdj5l0V6i3lkU++LZMUgNJbEpuBhIPMQd6zF5Y0eB1pwDmR2bSVxboaat
         2v8nG748awU9aIArGjtJUW0+1AEzP3puXWAYWEVp+/Gb/C/OSXaJoic91LtAEJqH7Zb+
         2JzQJ948ySTWqcpF41QnxMGNtsJwe6qSwIyXjeeS/yoHH9EyADsM9CzifQlPrS6BgP29
         GTPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774340903; x=1774945703;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k/R4UrJ3i0AKSFB8S0BGmvzRVh7LGwkVlhjThqkyhKg=;
        b=NY6LTfhcOJL1JLYmMuSdl3ThL81DbhbOClh7ANmfEx/SBrC9MjGCS70J/pYm9jberu
         932n2Js9zrrY+IqK/UaTzUOfOM6cIsXWBu9+FJ9Vqp83ozv8scCD3yE+Qx6shS2JZ+Gs
         nSmykaOPaN+qlr4ygB7on+2vVuqT5ZsfaYr9sb4zCYm/Qbf/4G/gwG/XW0Lbetd3wcGa
         0XiE2UVG9OFsgVsJknBfIc0L0dbqYJOrG83Kc4N4tkdaFDIyIXxEVXrGPmP9QCoVR0JR
         MaL06u+UUcDe4yXf9TvTFOIXNpcmeIuugrXKtBVujwbcqfavofyWIm7ZZzSaaB+9iY8u
         be2Q==
X-Gm-Message-State: AOJu0YwgZp+3vfSc6NWAkIeTnNnq/jyyQ+yAb91xyyKNLXN0Od7rcQLq
	+mdJcNwxZJ54PKqtyjwVlDPlbeWXCn1qSxRdeD59IVM8zW1UvFHHYoQ+WfHFjOiMz5tD96NR68z
	Efovn9MjxsSK4pZi9H+JwH/AKNLqE9a/u8EBJ1KST
X-Gm-Gg: ATEYQzxE9l3B/miowUXCF4VJOFFrORV+EERr5ic9fjqXSTn0zgsVmwOlApFwE4BFvDH
	I5RQJzL8WquuATL7A68MXAH1VrNDdEQZUz29U4FsTsy75SCIV+APyNLHzS79nVRqMHIsqxOqBHe
	85CS4sVWPBs4Rd4eElCro4FPFDcs6MQrE6Thsg04zGFWJab8HhYJK9QQzp84d3nyY/YU4T7ph1o
	5urDXIIh4H4yICYiUT4sHqtj0WAwVCSv2pVH0Ob0InK8VJlz2HgVJL9hzdLkSpSU+Up4/oZoCq0
	EBznW3U=
X-Received: by 2002:ac8:7d8c:0:b0:501:4eae:dbfc with SMTP id
 d75a77b69052e-50b7154b225mr8207991cf.5.1774340902858; Tue, 24 Mar 2026
 01:28:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOdxtTadAFH01Vui1FvWfcmQ8jH1O45owTzUcpYbNvBxnLeM7Q@mail.gmail.com>
 <CAOQ4uxjuAfCJXGRchDf-7d+uCS+8=Du_Y8OzgX15w4-fOR_oHQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxjuAfCJXGRchDf-7d+uCS+8=Du_Y8OzgX15w4-fOR_oHQ@mail.gmail.com>
From: Chenglong Tang <chenglongtang@google.com>
Date: Tue, 24 Mar 2026 01:28:11 -0700
X-Gm-Features: AQROBzDDTcU2T2aPK1OlAz0eukcGSLH7JjmZixCRujqVcZW31tErSWlhhWfyG3c
Message-ID: <CAOdxtTY9yKa5ZfzkoJYK_P=_mKygy1aQmCYfDdXo-xeU+pxqbA@mail.gmail.com>
Subject: Re: [REGRESSION] fs/overlayfs/ext4: Severe jbd2 lock contention and
 journal starvation on concurrent copy-up (v6.6 -> v6.12)
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	regressions@lists.linux.dev, jack@suse.com, Jan Kara <jack@suse.cz>, 
	miklos@szeredi.hu, tytso@mit.edu, adilger.kernel@dilger.ca, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, Kevin Berry <kpberry@google.com>, 
	Robert Kolchmeyer <rkolchmeyer@google.com>, Deepa Dinamani <deepadinamani@google.com>, 
	He Gao <hegao@google.com>, Fei Lv <feilv@asrmicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Amir,

You absolutely nailed it. Thank you.

Regarding the test, you are correct: the rm -rf happens in the Docker
build phase, so the timed test purely measures the burst creation of
the new __pycache__ directories and .pyc files on a clean slate.

I checked our environment, and metacopy is indeed disabled by default.
We generally keep it disabled for broader compatibility with various
container runtimes and user-namespace tooling that expect a full
copy-up.

To test your theory, I dynamically enabled it (echo Y >
/sys/module/overlay/parameters/metacopy) and re-ran the 20-container
concurrent test. The journal lock contention completely vanished, and
the times dropped from ~27 seconds back down to ~4.3 seconds, fully
restoring the 6.6 performance.

I am currently building a custom COS image with your suggested 1-line
patch (ctx.metadata_fsync =3D 0 && ...) to verify it on our 96-core test
rig. I highly expect it to be the root cause, and I will report back
with the benchmark results as soon as the build finishes.

Since we generally keep metacopy disabled for broader compatibility
with container tooling, your proposed patch to make metadata_fsync
opt-in would be a good fix for us.

Thanks again for the pointers!

Best,

Chenglong

On Tue, Mar 24, 2026 at 12:53=E2=80=AFAM Amir Goldstein <amir73il@gmail.com=
> wrote:
>
> On Mon, Mar 23, 2026 at 11:03=E2=80=AFPM Chenglong Tang
> <chenglongtang@google.com> wrote:
> >
> > Hi all,
>
> Hi Chenglong,
>
> >
> > We are tracking a severe performance regression in Google's
> > Container-Optimized OS (COS) that appeared when moving from the 6.6
> > LTS kernel to the 6.12 LTS kernel.
> >
> > Under concurrent CI workloads (specifically, many containers doing
> > Python package compilation / .pyc generation simultaneously), the 6.12
> > kernel suffers from massive jbd2 journal contention. Processes hang
> > for 20-30 seconds waiting for VFS locks and journal space. On 6.6, the
> > exact same workload completes in ~4 seconds.
> >
> > # Environment:
> > * Host FS: ext4 (backed by standard cloud block storage)
> > * Container FS: OverlayFS (Docker)
> > * Machine: n2d-highmem-96 (96 vCPU, high memory)
> > * Good Kernel: 6.6.87
> > * Bad Kernels: 6.12.55, 6.12.68
> >
> > # The Bottleneck
> > During the 20+ second hang, `cat /proc/<pid>/stack` reveals three
> > distinct groups of blocked processes thrashing on the jbd2 journal.
> > The OverlayFS copy-up mechanism seems to be generating so many
> > synchronous ext4 transactions that it exhausts the jbd2 transaction
> > buffers.
> >
> > 1. Journal Space Exhaustion (Waiting to start transaction):
> > [<0>] __jbd2_log_wait_for_space+0xa3/0x240
> > [<0>] start_this_handle+0x42d/0x8a0
> > [<0>] jbd2__journal_start+0x103/0x1e0
> > [<0>] __ext4_journal_start_sb+0x129/0x1c0
> > [<0>] __ext4_new_inode+0x7cd/0x1290
> > [<0>] ext4_create+0xbc/0x1b0
> > [<0>] vfs_create+0x192/0x250
> > [<0>] ovl_create_real+0xd5/0x170
> > [<0>] ovl_create_or_link+0x1d7/0x7f0
> >
> > 2. VFS Rename / Copy-up Contention (Blocked by the slow sync):
> > [<0>] lock_rename+0x29/0x50
> > [<0>] ovl_copy_up_flags+0x84c/0x12e0
> > [<0>] ovl_create_object+0x4a/0x120
> > [<0>] vfs_mkdir+0x1aa/0x260
> > [<0>] do_mkdirat+0xb9/0x240
> >
> > 3. Synchronous Flush Blocking:
> > [<0>] jbd2_log_wait_commit+0x107/0x150
> > [<0>] jbd2_journal_force_commit+0x9c/0xc0
> > [<0>] ext4_sync_file+0x278/0x310
> > [<0>] ovl_sync_file+0x2f/0x50
> > [<0>] ovl_copy_up_metadata+0x455/0x4b0
> >
> > # Minimal Reproducer
> > The issue is easily reproducible by triggering 20 concurrent cold
> > Python imports in Docker, which forces OverlayFS to copy-up the
> > `__pycache__` directories and write the `.pyc` files.
> >
> > ```bash
> > # 1. Build a clean image with no pre-compiled bytecode
> > cat << 'EOF' > Dockerfile
> > FROM python:3.10-slim
> > RUN pip install --quiet google-cloud-compute
> > RUN find /usr/local -type d -name "__pycache__" -exec rm -rf {} +
> > EOF
> > docker build -t clean-import-test .
> >
> > # 2. Fire 20 concurrent imports
> > for i in {1..20}; do
> >   docker run --rm clean-import-test bash -c 'time python -c "import
> > google.cloud.compute_v1"' > clean_test_cold_$i.log 2>&1 &
> > done
> > wait
> > grep "real" clean_test_cold_*.log
> > ```
>
> I don't understand.
>
> You write that Python imports in Docker forces OverlayFS to copy-up the
> `__pycache__` directories, but the prep stage removes all the
> `__pycache__` directories.
>
> My guess would be that rm -rf __pycache__ would generate a lot of
> metadata copy ups, but you write that the issue occurs during the
> 2nd stage. Maybe I misunderstood.
>
> Please try to figure out which and how many copy up objects this translat=
es to
> for directories, for files?
>
> >
> > On 6.6.87, all 20 containers finish in ~4.3s.
> > On 6.12.x, they hang and finish between 17s and 27s. Bypassing disk
> > writes completely mitigates the regression on 6.12 (using
> > PYTHONDONTWRITEBYTECODE=3D1), confirming it is an ext4/overlayfs I/O
> > contention issue rather than a CPU scheduling one.
> >
> > Because the regression spans from 6.6 to 6.12, bisection is quite
> > heavy. Before we initiate a full kernel bisect, does this symptom ring
> > a bell for any ext4 fast_commit, jbd2 locking, or OverlayFS
> > metacopy/sync changes introduced during this window?
> >
> > Any pointers or patches you'd like us to test would be greatly apprecia=
ted.
> >
>
> Very high suspect:
>
> 7d6899fb69d25 ovl: fsync after metadata copy-up
>
> As you can see from this discussion [1] this performance regression
> was somewhat anticipated:
>
> "Now we just need to hope that users won't come shouting about
> performance regressions."
>
> [1] https://lore.kernel.org/linux-unionfs/CAOQ4uxgKC1SgjMWre=3DfUb00v8rxt=
d6sQi-S+dxR8oDzAuiGu8g@mail.gmail.com/
>
> With metacopy disabled this change introduced fsyncs on metadata-only
> changes made my overlayfs which could generate a lot of journal stress
> and explain the regression.
>
> But we had not anticipated that workloads could be affected with
> metacopy disabled, because it was anticipated that data fsync
> would be the more significant bottleneck.
>
> Do your containers have metacopy enabled?
> If not, why not? Is it because metacopy is conflicting with some
> other overlayfs feature that you need like userxattr?
>
> Thinking out loud, I wonder if metadata copy up code would benefit from
> calling export_ops->commit_metadata() when supported by upper fs
> instead of open+vfs_fsync(), but I doubt if that would relieve journal st=
ress
> in this case.
>
> Anyway, please see if forcing metadata_fsync off solves the regression
> and I will stage the original patch from Fei to make metadata_fsync
> opt-in.
>
> Thanks,
> Amir.
>
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -1154,7 +1154,7 @@ static int ovl_copy_up_one(struct dentry
> *parent, struct dentry *dentry,
>          * that will hurt performance of workloads such as chown -R, so w=
e
>          * only fsync on data copyup as legacy behavior.
>          */
> -       ctx.metadata_fsync =3D !OVL_FS(dentry->d_sb)->config.metacopy &&
> +       ctx.metadata_fsync =3D 0 && !OVL_FS(dentry->d_sb)->config.metacop=
y &&
>                              (S_ISREG(ctx.stat.mode) || S_ISDIR(ctx.stat.=
mode));
>         ctx.metacopy =3D ovl_need_meta_copy_up(dentry, ctx.stat.mode, fla=
gs);
