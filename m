Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7299137C90A
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 13:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782221989; cv=pass; b=KDvg2YpffSdWYgHI9PTRoSO34CrgxB4QL+fLnnI8K6Gx8BYWh5r1xUIDuH3qw9T6rRd1HRW/avNTWVXn6du7yFdzq5sFwiYOWfViR4bI5h5AopP/zJ/0LmmtlsfREvlSkn+MA+sv1BZ3D6VkoF1WW08Oy9Plvtfi2+tQreNPsxs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782221989; c=relaxed/simple;
	bh=L4IfkIiw5zh3io2aytdRQLEjDNk9aml8dgDTZJ18U20=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pjw47Qe88M1+SmHmrwpXarH9eWU9JX8r0KH4h8PETeDhHHAiVp8Do++9UBjpyXm4XvUoBuf7zIR4Z3NA1XDxOyiJfgYTuik4q4J+wSDw4pkQPvx1cNeJpF1UtmrrFXbY8LnPtGaLA3o6lOSmO+R/e+T6ff5JDJDF0TfK6Mz2bdU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cLIpvkaX; arc=pass smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cLIpvkaX"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-804e46366d7so22480137b3.2
        for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 06:39:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782221987; cv=none;
        d=google.com; s=arc-20240605;
        b=LBgvwgR/Sath7HnwxXPNUmfa8Cc1HsivpYplNi1xhO1owtr7mMk12hJMOF/xCDjxWR
         q4S4CStLSHUXd3gzabAaxWRBtk4tclFNYL3RhQFUwHjcfVcAa7vKO4KtMyghgj5fCHMp
         5AjHr9IGZA4xE40CR4nKrarO+9+oNB4h/YtVJcO8nVIU7QYU4VREjEKSTO4lpxkUbRc8
         DrsRgGKappsaaJB5hToeq/Oe76trFsOs+b0AdKqhsiZY4RioNFSZR3Ums1DMYXnsLyVR
         TikU3GGcPWetCCF210lbzj3zTSA2vaZoCPyCNkbtnvhdXkapHxA7aTrgtemqFGrMrhxX
         DZrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=L4IfkIiw5zh3io2aytdRQLEjDNk9aml8dgDTZJ18U20=;
        fh=5CFVcyFSLEWjD4RWbVUG5lxrnHk7tXiGuzInlQKfqjI=;
        b=bE2aDA84Q684Nyp1d9RknydQTMkfZTMC04kPwwdK5yntrhc+qxOz3ntgfwYQ5e8Lq/
         yLRfxyw4mItWdHFJDr8JHh25C+B2lj+D1Daf4PzDaqBUDl4hhEQfkvuORsXkIKyA6cWs
         2h+CMqW9Qdd0UoC9oK/5arplwLUvPKfhwcdLPPDQPvLeSUfstgMB7gFwp342emrAeFjT
         NSJn9Ditw2BYrNVH+as5/nQxpuNAvWNIvj8Y5D3SDrlGsTSg/p+FBRB5Qp5POnibPxBP
         H93TfHkEbOhrBtKiuKHyIKNoDUEw1TPGStTBahic0RJgmHtBPkVal/E78z+jvITRnVgA
         N5jw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782221987; x=1782826787; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L4IfkIiw5zh3io2aytdRQLEjDNk9aml8dgDTZJ18U20=;
        b=cLIpvkaXey+ld7qiY/Otj9W2Y6JGbamesKY6QJD25O54KbnUtFDObPUfVDXTaliS12
         spTbl4I7jpT4WwOmZgF72CY0GvJd+19F/g9HQkmlQijP7CmFE/LNtgdq4oVosL21ifND
         UEg6qWkwdy64MJB2xIKxK9SII0EssYRYg38vOZen/VaImTZ8PCowjO8wt5Y9xcZj5nke
         3Lx69A2uum9i9kDx5DOWAYGKvZAEOhYvX2BBYKLUvOW5N9VTGFw6K9IACmbFnvQhtYoz
         sIvZRO6jR/CotskIPlTUjNqW18DPOyrsBotKFsd2LDKNduipAsi52nS8Jm4F32wN6nje
         T7tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782221987; x=1782826787;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=L4IfkIiw5zh3io2aytdRQLEjDNk9aml8dgDTZJ18U20=;
        b=R7YUZclXcYRl7W/COiDE/xJfZolccQ7lI4WOaFD3cUYtjuTxSdMNn+gcdrL6hfEntc
         Fk0/vSLLBnKrIMuJDcOJlLfF3B+2iFj+/gCM6jnqIl2F5oM6upfj2oIA03JlWbFdCS47
         pfxtP8ki3yT85oO6d9eniCrqo1sHinX6awpSBTWTzKP7I81VOvR3R0HSQVtxbffoOXTn
         3beyw5G/HQLs/ZvaX3kVBSm8PGfjkR6zTGRkQQg11XLksIHsEwT4+6Iwt9thHwBAB3OM
         6ysMjryhSgb8w0DEhM8DhpWQZjvin5TXquZl87j4yVmGXoKBt3jpQeZxWajYLtkKYk7q
         asXg==
X-Forwarded-Encrypted: i=1; AHgh+RplmBVas+oXQOtEEwPlyDZfXYkr4cWaIZG844T5ha+Asm/22fQ+4i5gLZIqpCiMANTUKYKXCUTyKzTA4ybN@vger.kernel.org
X-Gm-Message-State: AOJu0Yyz0nTk/2dN08RdB38ySuxPwm5h/kJ6wlquT71dAHmUi6k5/m6r
	xSxE1qvFeiYeujThrLwVS4MEHc8ntuE5SjtTtj5fV56hO41EnDREEjpThtlvsKp6ToSUMYRjENP
	UC+S6QqOTs9k8CEya/loyh29TY9g62nE=
X-Gm-Gg: AfdE7clqfcL/BSv9sZjXe2DaSClUGVR9cyAGymYfwTC3j8x56GUg4zmRNdm8AnT4qQ3
	mz43KhAZpQesM68mxRJUSFT+X1GJf3sSWyKcZlfUyacU+2xnDGBSTKDkTmNskLKk4jKC7dLaWII
	liblHWC1v0J4ZVMKR0hRF6yyNaspt14EKqohPQ2CGhxdr0aO7xVYaxo4hQ73CJLZLs7KROuqH7p
	Zvaz1V9uL0D0xLxFJLOt38qeNsv/6UvauCyFBvwauG1tNzFMAcZREmVuXfr6rDBsdoczSAhe4ve
	U39Pwq3OuvdfErkPtVK/FP83IPbgYg==
X-Received: by 2002:a05:690c:4d41:b0:7f5:b3bf:88e with SMTP id
 00721157ae682-806be6eb1b7mr29713817b3.0.1782221987298; Tue, 23 Jun 2026
 06:39:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260623084337.54344-1-laoar.shao@gmail.com> <7c986c19-75d5-4092-a08a-4f865947e7ca@linux.alibaba.com>
 <CALOAHbCEgWi2MjFRO7o9mDtho5TnkLvruK8VgOE=zKdEB42AdA@mail.gmail.com>
 <80869b29-0791-4f63-8fa4-24bc039ce701@linux.alibaba.com> <CALOAHbAKVF7bLcT_RA8xP8djkSFBXfQiw8h=jCs_-jknnqHioQ@mail.gmail.com>
 <7f9e379c-186d-41de-926d-bfc020e6c87c@linux.alibaba.com> <CALOAHbAY-3GAd=7DsA74W4ax7aPdXC7ecYt6b+tHoxFu754ZjA@mail.gmail.com>
 <bfdf1d1e-2313-46e7-8567-da2a363d6b3d@linux.alibaba.com> <CALOAHbAShZ-xYWw5yObqea4hB-4=NmTz1HiKQrApZpxsHvG_wg@mail.gmail.com>
 <ac56e537-d095-487b-8272-726d6739d0af@linux.alibaba.com> <CALOAHbCBo2eB0xVoSv8Vi+r3DwbwTticismFSL3EXyYuwFkEzA@mail.gmail.com>
 <13bb8cba-c82e-4a41-aff1-0a6418873bf1@linux.alibaba.com> <CALOAHbCkbSBVqUStUbWB=4vUUOEyB63yMsXvS_cZUZOwr-nmew@mail.gmail.com>
 <a5a1b56f-0b1a-473d-8fc9-8cbfba85813e@linux.alibaba.com> <CALOAHbCrvbvT04O3v+p-CmdqVN2BGJYKj6F7we70kPwbs-hmRw@mail.gmail.com>
 <b4d43064-7a7d-4d65-b65c-56e80d47ed17@linux.alibaba.com>
In-Reply-To: <b4d43064-7a7d-4d65-b65c-56e80d47ed17@linux.alibaba.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 23 Jun 2026 21:39:10 +0800
X-Gm-Features: AVVi8CeK8zXAwIHu1NY7tOKvjHMtQPkwav3by9RB0Oiklh2Gjak-msamIZ_aVLk
Message-ID: <CALOAHbBGvTNFC=ScHWVG-MLqsKM0P6oqYpbA_Ls2G5g3kSWAkQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: Allow changing default fsync_mode
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: miklos@szeredi.hu, amir73il@gmail.com, linux-unionfs@vger.kernel.org, 
	fuweid89@gmail.com, Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Jan Kara <jack@suse.cz>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2026 at 9:35=E2=80=AFPM Gao Xiang <hsiangkao@linux.alibaba.=
com> wrote:
>
>
>
> On 2026/6/23 21:19, Yafang Shao wrote:
> > On Tue, Jun 23, 2026 at 9:11=E2=80=AFPM Gao Xiang <hsiangkao@linux.alib=
aba.com> wrote:
> >>
> >>
> >> (+try to cc more FS people for visibility.)
> >>
> >> On 2026/6/23 20:47, Yafang Shao wrote:
> >>> On Tue, Jun 23, 2026 at 7:59=E2=80=AFPM Gao Xiang <hsiangkao@linux.al=
ibaba.com> wrote:
> >>>>
> >>>>
> >>>>
> >>>> On 2026/6/23 19:38, Yafang Shao wrote:
> >>>>> On Tue, Jun 23, 2026 at 6:25=E2=80=AFPM Gao Xiang <hsiangkao@linux.=
alibaba.com> wrote:
> >>>>>>
> >>>>>>
> >>>>>>
> >>>>>> On 2026/6/23 18:18, Yafang Shao wrote:
> >>>>>>> On Tue, Jun 23, 2026 at 6:12=E2=80=AFPM Gao Xiang <hsiangkao@linu=
x.alibaba.com> wrote:
> >>>>>>>>
> >>>>>>
> >>>>>> ...
> >>>>>>
> >>>>>>>>
> >>>>>>>> Again, I don't want such customized messy breaks userspace
> >>>>>>>> again; with that patch, container runtime needs to consider
> >>>>>>>> if `volatile` is the default which just breaks the existing
> >>>>>>>> containerd versions.
> >>>>>>>
> >>>>>>> I'll leave this debate to the overlayfs maintainers ;)
> >>>>>>
> >>>>>> On my own perspective and be responsible for common users
> >>>>>> (and as a containerd maintainer [1]),
> >>>>>
> >>>>> No wonder containerd is getting harder and harder to use ;)
> >>>>
> >>>> What do you mean, can you explain exactly?
> >>>>
> >>>> You're just adding a new way to break the existing
> >>>> applications, no? You just breaks previous shipped
> >>>> containerd.
> >>>
> >>> It's your responsibility to handle the cases where "strict" is
> >>> explicitly required. Please do your homework. It is not the kernel's
> >>> fault.
> >>
> >> How do you modify the existing applications and scripts
> >> to adapt your incompatible new Kconfig?
> >
> > Why do you still insist it's "incompatible"? As far as I can see,
> > mounting on the same directory is a very rare case, especially in
> > production environments. If your use case relies on "strict", then
> > simply don't turn it on. Everything across our large fleet of servers
> > works perfectly well with it.
>
> I've listed my reasons since this patch is really a red
> line for me (otherwise I won't comment your patch, it's
> none of my business.) and I've said enough, and the
> upstream kernel + overlayfs does not work only for your
> company:
>
> You should first ask and gather how many existing
> applications which can mount overlayfs will deal with
> your new Kconfig; if not, what is the target audience
> of your opt-in Kconfig other than your company as a way
> to workaround "docker" upgrade.
>
> Or if you'd like to introduce a new incompatible "overlayfs"
> (an overlayfs cannot mount again by design + volatile by
> default), I think we should name it as another fstype in
> order to avoid breaking existing applications.

I'm exhausted. We will keep this feature within our local kernel.

--=20
Regards
Yafang
