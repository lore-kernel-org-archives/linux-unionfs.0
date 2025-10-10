Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2882FB08F
	for <linux-unionfs@vger.kernel.org>; Fri, 10 Oct 2025 15:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760110866; cv=none; b=fykApS+H8j/2zRQEPJBKSdZj2sXFhR9ZUcuxdgTmh2dbHWRwH8h1vSOyZ6ifjMxn00q54JaOeN6osp3CZDd8XMgS8DhCydR7tf90kfWRLTctvFbcwmtgwaopnBW4GFhZZIXRPs2twOAbX+cfDMh+eDM/ERE3X5mKWX2S6fIld8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760110866; c=relaxed/simple;
	bh=xOJuDOIlas451FiXAAHgBhsNRzt6HStLrb4Y3mKzjBE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZymIt/fUOVaE8JTIispMevgwd1+izeSLF+7jZVEnUERTJ3rAACKa6WHlROHaL3kHPl30fFzwOlgzUaUi6VBG9/kNNg+Gswf706KVp0U8u//fP2F1SP/0LFxuSwUhZhQngOLNnqmCahcrYJPc1XKqqqcIzL73/AVKqdZv5JE7pH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HAjzMCP6; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HAjzMCP6"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-634cef434beso5128159a12.1
        for <linux-unionfs@vger.kernel.org>; Fri, 10 Oct 2025 08:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760110861; x=1760715661; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pNrx81VuCOUnlOhs53ChqFbGZmsPkwHURyqTboyD4SA=;
        b=HAjzMCP6WRFHv/sreS1KWvOy6uXorsCkmnygvRunN2bqmGbBktPhZ9U6HGiqyMP0cZ
         vcYM6+1DmRsf5UmsVPkExeA4WxM6kbNyB2VNxeu4ENsh3hpq9Wt6RuMc1X8lZ7HSIaWs
         EqIktZDYJcyX5J8DP6WL/i/WTfjV7NdvFv/trIlSgKJyMxW0Aisbc1WLCgoTmSmzq2tU
         4rcf7rzcR3yi7nRiW4ojKWvGw1hg2qy38twmbdGmAAtI2oCDGcmLTkDX+d1WAmlwHDBy
         KkHR6uV/go7sPmZTc+/dBMRFzIs+gbgdJBlT9wfbYDR3m+TfJFt+zxi0ii5lQeVsCD/E
         0i0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760110861; x=1760715661;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pNrx81VuCOUnlOhs53ChqFbGZmsPkwHURyqTboyD4SA=;
        b=bXpXZdqI5DwE3/qQI9oRSIUbuoj6Ery7QaznsluLjSYgFQsjIC3IIbUPxidk5sUSpG
         2gc0r6tSwM7j47o2Skvk6wlYLLolfjLFRGN4qaPIibH+jmOtBA/pMD0d3GEhwjL9Ds9c
         2I09UneDzXslaI94gBpPqq1iIJEErZuVsq/Bi4kXGdlhnbnAHO0TLeZgpEf9OsbeeglX
         0fyabvAVJMSvE9MGKhLbQYpgf7RbbwKzZ1TMEVu4UcfLVbbVp/b695uAfFxmM0uGKPmf
         X1SyUCN73mJnUziKoxceBc3yDPguFKg/L3XmEztpTjg0urf2F+DphiRIuwiwLiJilnmp
         tppg==
X-Forwarded-Encrypted: i=1; AJvYcCWqHN4bsn5ScNcmQ3YhFlqxJxnTdaLw92u0z3tRoVK4Ouktw+4zyD6FzuexvmQNymUnShV5EsoaIGb8TZsD@vger.kernel.org
X-Gm-Message-State: AOJu0YyN7arpJm2g/9k0jO55t/8u59hZEpwsK5PaTV0W4S9TYvQ0wiff
	FLUsLAuZ2NIIfq+r14zK865PfuNyFhFVe3VJ2MykpiUa99X/RBGoJciBw2aNfeCVoooxUxzHrd+
	S8oBzZF6vMDdWBTSUDCXR0FG3gCpYBSQ=
X-Gm-Gg: ASbGncvE5PDl+EYoPhEYY/X59IL4V16XWudr2QUQKnSn2aL/GsNsz4Yn+UH1/w9eGqg
	KXfuxUvVSDpidKfS60ahWOOcr7g9He1h7OCfihggG+Hm8MnS00+NwPEtWVcQQ557T82uyYLkKmt
	/L/40Ph4baeNkL+nsLY0BQdfdEVi5TTm4Q4m+K+dffHPAM6ixyUlHGW02pbzlzUxYem1BNesYOr
	QEr8VL0TO0W2bsQPBW56Wd4+BH9SecpdQl7JuNnmcBi2BuMFfQfcWe4cCLon4iaV7w6
X-Google-Smtp-Source: AGHT+IFsVwlKz3dpQMSn0djeXDN0dipdKA/kgBAE2NxkawkzYdINOsshggkYLd2MlBJ2D7HcedRqmChtEct9QlvTNTA=
X-Received: by 2002:a17:907:3e2a:b0:b2a:47c9:8ff5 with SMTP id
 a640c23a62f3a-b50bd050daemr1405146466b.10.1760110860769; Fri, 10 Oct 2025
 08:41:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251009075929.1203950-1-mjguzik@gmail.com> <20251009075929.1203950-14-mjguzik@gmail.com>
 <ua3koqbakm6e4dpbzfmhei2evc566c5p2t65nsvmlab5yyibxu@u6zp4pwex5s7>
In-Reply-To: <ua3koqbakm6e4dpbzfmhei2evc566c5p2t65nsvmlab5yyibxu@u6zp4pwex5s7>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Fri, 10 Oct 2025 17:40:49 +0200
X-Gm-Features: AS18NWBB3Bmc7XAi8sS7M18NKhoZbvSirs7my7gPJLr4eYk4Rf7Ljkokn3EGE5o
Message-ID: <CAGudoHGckJHiWN9yCngP1JMGNa1PPNvnpSuriCxSM1mwWhpBUQ@mail.gmail.com>
Subject: Re: [PATCH v7 13/14] xfs: use the new ->i_state accessors
To: Jan Kara <jack@suse.cz>
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, josef@toxicpanda.com, kernel-team@fb.com, 
	amir73il@gmail.com, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 10, 2025 at 4:41=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
>
> On Thu 09-10-25 09:59:27, Mateusz Guzik wrote:
> > Change generated with coccinelle and fixed up by hand as appropriate.
> >
> > Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
>
> ...
>
> > @@ -2111,7 +2111,7 @@ xfs_rename_alloc_whiteout(
> >        */
> >       xfs_setup_iops(tmpfile);
> >       xfs_finish_inode_setup(tmpfile);
> > -     VFS_I(tmpfile)->i_state |=3D I_LINKABLE;
> > +     inode_state_set_raw(VFS_I(tmpfile), I_LINKABLE);
> >
> >       *wip =3D tmpfile;
> >       return 0;
> > @@ -2330,7 +2330,7 @@ xfs_rename(
> >                * flag from the inode so it doesn't accidentally get mis=
used in
> >                * future.
> >                */
> > -             VFS_I(du_wip.ip)->i_state &=3D ~I_LINKABLE;
> > +             inode_state_clear_raw(VFS_I(du_wip.ip), I_LINKABLE);
> >       }
> >
> >  out_commit:
>
> These two accesses look fishy (not your fault but when we are doing this
> i_state exercise better make sure all the places are correct before
> papering over bugs with _raw function variant). How come they cannot race
> with other i_state modifications and thus corrupt i_state?
>

I asked about this here:
https://lore.kernel.org/linux-xfs/CAGudoHEi05JGkTQ9PbM20D98S9fv0hTqpWRd5fWj=
EwkExSiVSw@mail.gmail.com/

> > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > index caff0125faea..ad94fbf55014 100644
> > --- a/fs/xfs/xfs_iops.c
> > +++ b/fs/xfs/xfs_iops.c
> > @@ -1420,7 +1420,7 @@ xfs_setup_inode(
> >       bool                    is_meta =3D xfs_is_internal_inode(ip);
> >
> >       inode->i_ino =3D ip->i_ino;
> > -     inode->i_state |=3D I_NEW;
> > +     inode_state_set_raw(inode, I_NEW);
> >
> >       inode_sb_list_add(inode);
> >       /* make the inode look hashed for the writeback code */
>
> Frankly, the XFS i_state handling is kind of messy and I suspect we shoul=
d
> be getting i_state =3D=3D 0 here. But we need to confirm with XFS guys. I=
'm
> poking into this because this is actually the only case where we need
> inode_state_set_raw() or inode_state_clear_raw() outside of core VFS and
> I'd like to get rid of these functions because IMHO they are actively
> dangerous to use.
>

I'm going to address this in the other e-mail.
