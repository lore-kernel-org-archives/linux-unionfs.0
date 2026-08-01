Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5B238D686
	for <linux-unionfs@vger.kernel.org>; Sat,  1 Aug 2026 18:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785610472; cv=pass; b=c241BObDbaKwAXoY4sFakbLGyeTI95mKGlbkkxjDO/nHPOWVR4XZLQtxhvTcUyC3KkVj61kxzH/8NRICGKzu44wQgH/A7sdsTdOylkP5WbRqUg55HxBAiig6Y9lHpFELTTqn7DtbCFViA/7595fGeAyjWJIO8KkUUJErdRm2jM0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785610472; c=relaxed/simple;
	bh=s5Gfpg0zgBC841yiwSBnIRqhIhRvVPkWqEeOCqHbcEY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=DJJff5R6fYDAcM/1bGVzfLs/d/h5o1030H0x98VjVd362PHfAxpt4cWuXJbvNVTSYTP5Z2lxfe3n5RQQC/lgYWe09sg1e8thHRWLkKsrQaP3WjkYhkqwW5JE0WsX0zni8bNSpyOmHB2dJ/kKtfWqJvu3mRYCqLH1/b1cxbuMJIA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q+kHRWES; arc=pass smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q+kHRWES"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-69c5fda04a8so3808741a12.1
        for <linux-unionfs@vger.kernel.org>; Sat, 01 Aug 2026 11:54:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785610469; cv=none;
        d=google.com; s=arc-20260327;
        b=mUDyR+xqyOvulXLp6/QTLlrQaWyervfam4Pk8nZ0fFBOEBHnmOjZKmF9OGET+Y1fL4
         rXdnHh94h1l2+axX0z3EPGzlAwA3bccaaltbYDV/45RjgxjtOvAOxmQWa6xBbSJx8Kdd
         pHzJMgnyL0xbNvZDiVMLy0t0s0g6VCqapvvqDw4NPoWBZwxTNWk+Bgl2wXBcOh+8kFsS
         kfJxmn78rQci/KNPwYvt0ANGfojoy4JGdocpTuygfFsIJp7kcE41/kfMbcqIgLlMtcDH
         jynsodNYcKNwARmsOgwYuAY29vFjLfvjCWeDZKY8exrYR643dV9NgJ3T7KzusGqXlVM4
         2flQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=72LrGKvsXvQhEBxFk1sMzgi9EvOeboavfgQ4tZHipRM=;
        fh=+STfu/UGXGOy6Y2UcP0aM+vjgCLcwELz1LBT2lqtwYo=;
        b=LgIrWq2unFiylL+va8+GSGfzUnmOgnN3+tydJ5nLzyOs2IBVWQQpyiWx2loLZh+jYt
         rt+s/qdG0JLDomK9KXAABEAO2ytUgaq+sD+T1NMOV2Gj/+0DTqGIbs2DvVTUt3XC4g6J
         p4NTvnt6cadHleJIlm2uPfTAqG5E8Fs/VdQtQUcKGKfIwnur3L5gHJomDsERxzoHJ0qE
         SapS8IAAYmt31BSIAWvX4j02YGwbnUfURzdiSB0Buvd7OIGDFIbGG6m2utIWhj6XWC55
         McWkARCvAmw8ad4vpAP6sJ3y7YEBZZv3ZtKbjPp4fvY4E5ZeNPwL4us5Bcart+lMUvzj
         Pjjg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785610469; x=1786215269; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=72LrGKvsXvQhEBxFk1sMzgi9EvOeboavfgQ4tZHipRM=;
        b=Q+kHRWESE+/mDhPdNUEaTBiI0dlSMlGRS9I+KEQcijy7NatsihntEg8uxW2LNdePLu
         iOYY3eLTxM2xfGqsBSRRhZzGsboAiQ6zIiX5VQ+0C6yBy0EiJVFUSjtiAzH+NP093fby
         JQRGgB9sTlGQtIcCPfQtt9QLBxfNoH+pdRM/xUY7bz28Cf/27PFw5DCdpc75zy0rdj6c
         yc0N0WZTj/wh+NVsVUd4ZpODTGSJpbNJmP+KpO2OJz6xYYNjmZ8EzEdW3VgDrMvXVixY
         FOLVs9+xwo1dsmgbD3ypIyt/6Ku36WLWj57eePHrUMbRNtB/JzAz9GzYbpISOJkbjIvW
         h1Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785610469; x=1786215269;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=72LrGKvsXvQhEBxFk1sMzgi9EvOeboavfgQ4tZHipRM=;
        b=hfh08frIWxMqH8fG9ezI00JCKK0DbLXHrUjGQhwtUVnqSbqaC4HaFGyf6G01YzkYum
         1B9SVjThgeNarNu+5NVF0xhFNl5SW4i9iYhEYIXLf1irxYBvyD+Q17xXrCL3VlMMHI/9
         DzzfNAv3xqbJ0zI/HBvK0WuLQrYdvaPiLxLZMZVIokHv1d6Ld+6alpnv/4OrLGNeFwG8
         rWfvuQNx+V/fUhLSTqb0hML+27K8AoFjO8uo+OoeRDkPfPZYn3Df6fcyvkD4hIy4Bxf7
         60uRMBnsn3jJLrlwlHiCSI0BRchlJ7ctRvbDDH1ByDGTXeeh6Y5IYJhLF8pUyYqgbulh
         p8pQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr+Di5UwlyOdDfPIzZYHeCZJ+JP73WHZqk6qkLC5yydoyxGRMUf3HNC0rtAagUTC52lKdFbnCf5anh6cGUz@vger.kernel.org
X-Gm-Message-State: AOJu0YzdrIQRnklpdkVgf1bvP8DAt2y+42lc2C5166Jqx5/xvGF8JOTH
	7X1+t4AB+iSfWcMDexth2CpfIERERLkH+p3KBJyFAa9a0zAWZStn3fzWYojaNGsrIv9cw8OXFvI
	IAEpkKOWh+39dRxQS53GEKqT1OZZ+30g=
X-Gm-Gg: AR+sD100lDmeHc0gvFa3K34qitd4QW+irPxHYlMqhngg/9Fe7Tywc57GV6ASXUfP/RY
	c/nLsmYqnd94GvxXWQlwIEIjcgWOOr0IQ7HREjdf1V8xfC2uJqY/vBc3wsrlcQ1HGzICqLNiIl3
	J8lQCZGkVXiPvwf/XDGfQ+C1YZcDlbiDD3oyOfdz9h/23x5winAvJdafVIWFGt591VPr/61Z2X7
	DJGm16/Ec0Yc8Jjp1UYdp2a2EsboFrMV785q54YAmQv6oQCCEkhH/Y3Npvruj2+bvo9CV6QM1ju
	DvEFu+y8EMudM+FY/zeJd1GktYxoOFf2zDbRTO/lC6EmVg==
X-Received: by 2002:a05:6402:52c9:b0:698:ac8a:9a21 with SMTP id
 4fb4d7f45d1cf-6a0a7c5e513mr2672190a12.8.1785610468878; Sat, 01 Aug 2026
 11:54:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260723114848.1212429-1-amir73il@gmail.com> <amKjyp78ngW2Kmku@debian>
In-Reply-To: <amKjyp78ngW2Kmku@debian>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 1 Aug 2026 20:54:17 +0200
X-Gm-Features: AUfX_mycy3CLDRPo1M1-mDD8CDdSTIfqZUV4MPkGVFCoOu90Y4JLcLs7KyDRwqw
Message-ID: <CAOQ4uxgcU1EzsOfWZRMzubso1bd-QfQ54w_TfBBCniQVSAHoiQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] Proposal for Cross-fs copy_file_range()
To: Amir Goldstein <amir73il@gmail.com>, Christian Brauner <brauner@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Daan De Meyer <daan.j.demeyer@gmail.com>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 24, 2026 at 1:29=E2=80=AFAM Gao Xiang <xiang@kernel.org> wrote:
>
> Hi Amir,
>
> On Thu, Jul 23, 2026 at 01:48:43PM +0200, Amir Goldstein wrote:
> > Hi all,
> >
> > Daan De Meyer requested a way to do copy_file_range() from overlayfs
> > to/from another fs, where if that fs is the base fs of overlayfs layer
> > the copy could be an efficient clone.
> >
> > TBH, he also requested support also for cross-fs clone_file_range(),
> > but I am not happy about providing that.
> >
> > copy_file_range() already supports cross-sb efficient copy (e.g. with
> > NFS/SMB server-side copy).
>
> I once had a long-term goal of supporting copy_file_range() between
> overlayfs and EROFS

Between EROFS and overlayfs?
I think the proposed API is general enough to support this -
first the dest fs (overlayfs) copy method is called, which calls
vfs_copy_file_range() from erofs to (e.g.) the upper xfs and then
the erofs cross copy method is called to copy from backing file to upper fs=
.

> for file-backed mounts, as long as the EROFS inodes
> are plain (i.e. uncompressed). Such cross-fs copies could be decomposed
> into one or more sub-copies from the EROFS backing file to the
> overlayfs upper file, so the underlying backing filesystem can perform
> the actual data transfer. If the backing filesystem supports reflinks,
> those operations could even be implemented as efficient reflinks.
>
> This would greatly optimize overlayfs copy-up for file-backed EROFS
> mounts.

This optimized copy up does not require copy from EROFS to overlayfs,
only copy from from file backed EROFS to upper basefs:
- erofs should support for copy file range to another fs (similar to patch =
5)
- ovl_copy_up_file() should use vfs_copy_file_range() instead of
  vfs_clone_file_range() - or some variation of this

>
> I think this should be feasible, although I haven't had time to work
> on it yet. If clean interfaces in this area make that easier, I'd be
> very happy to make use of them and enable this later.

I think it should be pretty straightforward to implement this in erofs
however, calling vfs_copy_file_range() with the backing file would
populate its page cache, so maybe you would want to limit this to
when the destination file and backing file are on the same fs which
supports clone, perhap via a flag COPY_FILE_REMAP to
vfs_copy_file_range().

Thanks,
Amir.
