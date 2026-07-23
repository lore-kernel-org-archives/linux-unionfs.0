Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81ED2FF147
	for <linux-unionfs@vger.kernel.org>; Thu, 23 Jul 2026 14:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784816294; cv=pass; b=u6Z1qGH5MY0TpHWXlKxVsCxPjQSLHsP6LSo/jBaXZ/4uAF0iknFX+H8cdAuy61CZph/PZwRPVWWqBF7zSlyfIia6B+NzghgklqGOaIOXtHlxuP0bYNDgfD9KeU8FB652ZX+vMyTGN9dsMTVP9i3aNWwmFMcvkslzgDPYYhLrhJ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784816294; c=relaxed/simple;
	bh=N8tzJ8ycigpnp8bKwPx31LBLGqpkPT5YWOo9LUDjlg8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NXrTrX1+3Ci/aNEAorUKT3T8Q9OZ1BaVJLw7aiuy4ZvWGXmqo8UtcwSAaZnhTEWvZ14dl6b6l1hfFkXMHI8LVzJjWR3FaejOpfmTiK5yKLA+zyTHv4nSUUi1HZhecV1WbpVmaUT+3K+5bPYag8xBtFy7eGMFMAS8IEDazAyP31A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FtVHNDyt; arc=pass smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FtVHNDyt"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6986287534eso1322424a12.3
        for <linux-unionfs@vger.kernel.org>; Thu, 23 Jul 2026 07:18:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784816291; cv=none;
        d=google.com; s=arc-20260327;
        b=ipiBuhE8rUhc4/aJsyZiSAGyZsnzu4ilHklROJLfTze2TU+lsC0B6MVjHO9vdTEEm/
         wZWX3dK9f9mtQIR7frqh9MtqQhLaWwC6UafALHBzIL0nUtAO2s3bjxjqFSbPI0+RUoSf
         23nkixtGAP0SLyXDhX9o/x4LzyL5dGATJPgyA+SwivO6/S5Fujaxe6fdnOxhpYM9HxBO
         C59iKLyW42v4vNb/X3ccF0OdOPkwoAIr8b7U8blJishispjjMlM1oIsORMPM2RrNWEIn
         /M+WRt3Giq5T0pVCP0ZPGcrH0pehBRgp1qCFa6AR+9F7K+yefBb4GPCl4RIv4fBI+pVA
         2+Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=N8tzJ8ycigpnp8bKwPx31LBLGqpkPT5YWOo9LUDjlg8=;
        fh=96m73BzWOuL+hRlAsHkF4tGoUF3ThYxZotrBWQDRhl0=;
        b=cu2fAd/P3qH0RBlkv8b84P4zbLHznLsW2n/XvIwIVzmTOGRY67FsHQ9HXisxyL87aG
         VRdTUMtstU1S7ZQBQRBugRZ4HkeWAFc6VjAzoCEjkLnIvnuzqHN68vMnCtehix8qsKHk
         pMEvYpvRjARfbMGVaPFX9pSn1OY24MxiiTNh66H3IqA2eGoVdJNbpNfiIlXVwwfgfyoJ
         UMc0DGwXi06AMmoxPRa9zh9WbyzvfpFLBuDSwxejOGw6QaJr41D94dvBDOaanxR+GuIj
         CMfAh1YZF8DEwb1+OzF89N+9CCSUNSC+AvRXf90vpPFuOOfJH4cUUoC6gYvsSpTI1Gzb
         60Rg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784816291; x=1785421091; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=N8tzJ8ycigpnp8bKwPx31LBLGqpkPT5YWOo9LUDjlg8=;
        b=FtVHNDytHJqfU6emlRjNT1JU7rpg2wCmDDrDQourbT4qK1I0FHOzCfMgUisdmO01IX
         eM61Bhp788CHkEo/FEE1HtjX2pZ/bQEyZu8qh5AI7A+fZrTuvHSSbbqbA3cXvQPNAuTi
         zlVSULROKQXDNWjJ5BxDFn0wu0KcVDGXUs9nKL6LBTSZYZYqDIHfYtVeQQj48J3tjBnM
         t/eFalhMIEzgEzrtHCAJxTjUSeEIkIk+Ic08gNWSB+3urbW+MtP3M6V/j4XYen7y/1Jw
         XfkFICMyL0Oe/MVJ7sE9VcrDEA8qhjRkrtKtBPMvVFLVe7183Zxpn/K3J8J1g+06F/ZG
         6T+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784816291; x=1785421091;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N8tzJ8ycigpnp8bKwPx31LBLGqpkPT5YWOo9LUDjlg8=;
        b=sY7e1MeBJWlZ5zjFoDUhBKmCT2K/mJKaMYh/GtrZOREYuiEkeOlTJliiKTl1tRhzDd
         GelsM7Zgl0sU1hrjADvnCrzpHE7ETb81TdQxYv7USXai0mSUpp7lbmIQTATFcVLfTxrc
         AyH5WWhC24wmRWwawU25xr2MOJyrDUEcboX26NN0ip7yzSC0p/zRNuubH+ZS/9xF7RBa
         l1IPdbPtv7zsp0yzsfAj/XOOrwBG7VEQ3TF4OazIjMClTxV1UpUFkNkWUr/xrZ53+XSz
         cjSFcyXhcZBI1Y1+tQgDbRy7y/qZL2STErTXID6WXPIF6f5a6XPU1p66vKUPDvFSjFdf
         AOWA==
X-Forwarded-Encrypted: i=1; AHgh+RrTtFSNTVfD3bVFsNgAl3WzsjxFpE2vW87nOFjk5WfhnJam9+0JNz1Zn0OwJoTrEnLxq3aKRWiXM7QApUdw@vger.kernel.org
X-Gm-Message-State: AOJu0Ywc3Fij9LMohSpL61/xuYMLyXTyz59D9SoxXsleLmRK0kToatTh
	9cEzJNu54Ll7j9uHEuBcc3IMR01z1lUg3gGfzPUOBNA/J67pTLdJYWdGvVqSp/vlb5ASkGfnv4C
	d6e9RpE4E3K3vEAIVCH8bnu5JbhbP6zI=
X-Gm-Gg: AR+sD12+YEl5ELt/i20T3m+inlzExmeuoXXs3/SQzV0jgRYgkGDH8G+BRPab2cTIHX3
	eKkId+i8WFqrUpUNJX5b+sYe3G8GerY6MCly/pzZfVTNR+CLYGXscEOKQjaTAyUz0jkaxXWj01X
	nzwy4L9Xei7MLxvffTlOw2GuvxM6vvCszcQlpy5n9Z+Fg0QgSds9lA/JPEXj1CIjbk2dw3M2Umn
	Op3Wldi05PJpa6dmHHxt6odzNg3jDK7wiP42ZN5XUr+m6OdMB4IkfiKdxaMQy4=
X-Received: by 2002:a17:906:478a:b0:c15:ff7a:e56d with SMTP id
 a640c23a62f3a-c1c50d8b9famr145409966b.51.1784816290701; Thu, 23 Jul 2026
 07:18:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260723114848.1212429-1-amir73il@gmail.com> <CAO8sHcn=b94SL6KTfPtnqau++-g9CXD0LOpPjp4L+b9cu8mMSQ@mail.gmail.com>
 <CAOQ4uxjk_Se3dq3exxd5WS98g287HUMjVAucipxBX=T0W-8d6A@mail.gmail.com> <CAO8sHckGrgfPnyOC-V6AP+DakG8LBXTFRHZSchXxi02LPyfMFg@mail.gmail.com>
In-Reply-To: <CAO8sHckGrgfPnyOC-V6AP+DakG8LBXTFRHZSchXxi02LPyfMFg@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 23 Jul 2026 16:17:59 +0200
X-Gm-Features: AUfX_mwXdE-m0mzicDGGryu4GVMv_y80ZcvNzhuqfcDSPCqC27mGT47UT9hEgKE
Message-ID: <CAOQ4uxh7G44sJi2A=bueC=MNGjd5V+zoyTCs5USc6i6bCbFxDw@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] Proposal for Cross-fs copy_file_range()
To: Daan De Meyer <daan.j.demeyer@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 3:54=E2=80=AFPM Daan De Meyer <daan.j.demeyer@gmail=
.com> wrote:
>
> > As far as I can see, OverlayFS-to-OverlayFS, which is classified
> > as FS_COPY_SAME_FS should not have changed behavior at all.
> > That was my intention at least, maybe I have a bug (?).
>
> I am sorry, I forgot to mention that all of these issues are issues
> with upstream overlayfs,
> not with your patchset. I was trying to make the argument that to
> solve the issues that are
> already in upstream overlayfs and to introduce cross sb
> copy_file_range() we need to move
> away from recursively calling vfs_copy_file_range() within overlayfs
> (and anywhere else really)
> as its internals are really not intended for being called recursively.
>
> `ovl_copyfile()` locks the overlay destination, removes privileges,
> and then calls `vfs_copy_file_range()`
> on the backing files under the destination OverlayFS mount credentials.

Yes absolutely by design

>
> This has three observable consequences:
>
> 1. The recursive VFS call accounts one userspace copy twice.

I think that is fine or at least not so bad.
same "problem" exist for overlayfs read/write and has been that way
forever. nobody complained.

> 2. When the files are on different OverlayFS mounts, the backing
> source permission check uses the
> destination mount credentials rather than the source mount credentials.

You mean that after the fix [1] it is *also* checked by destination mount
creds after being checked with source mount creds.

There is no security risk here, so I think this is something we should
leave as a known and documented issue, because solving that would
be as complicated as what you posted and I don't want to go there.

> 3. Backing permission hooks run while the overlay destination inode is
> locked and after privileges
> have been removed. A permission listener that accesses the destination
> can deadlock,

There are endless variants to these potential deadlocks with permission
events. This was discussed recently on this thread:
https://lore.kernel.org/linux-fsdevel/xycqm3qrhjg3uplpmozwo7nterl5tnuarghow=
mh3h3mv3thh6u@apagf4kqlkg6/

> and a denied
> backing check leaves the destination setid bits cleared.

Nothing new here - not even a bug or a problem IMO.
The state of privs after a write that MAY have started and returned an
error is undefined.
Always been this way in all the write APIs.

IOW, all the problems you listed are overlayfs behavior by design,
which AFAIK have been like this forever.

Do you have any reports on new issues specific to this patch set and
the new overlayfs to/from basefs copy?

Do you know of any real world workloads that are significantly impacted
by the existing upstream issues that you listed?

Thanks,
Amir.
