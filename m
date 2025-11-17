Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF7B328B4F
	for <linux-unionfs@vger.kernel.org>; Mon, 17 Nov 2025 10:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763375931; cv=none; b=g7GgAWe9ptJLZGAs9dKcloUdTa2YLA640wfYcr4QbHdi4E3KC2QkbSYp6+VZNwqEgrs4tVfIC1tdffK95M7P4zJ0SwQeOkTv2sxBbsNCaJ+MxMqCOKXgsVN8MDekt0dQkIWWA7a6XWmx9ToOWSbD4hAd48TJhUW8L/1ZY7dTQ+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763375931; c=relaxed/simple;
	bh=A4OuYHNoNbmpT2j/hxsR/HSLdirQTZhZsI015gZWf1U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KwfEpC6g0B2WA2ZTaDJBNDW4F+xCqICVQ1xKkjgV4fVY5mWUy9CzvVMgYwstVTMGM6Y3hy7/ZiJEk/HoNv87nMD7LqIUU7yywFpdW3HE0ZTN6i1KAwAadHy6Xtf8DSm4NTOv3dMNPC11vISIArit118Ce2OYqzhdTc8klcFvKiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PqEtcWN2; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PqEtcWN2"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-64320b9bb4bso2807131a12.0
        for <linux-unionfs@vger.kernel.org>; Mon, 17 Nov 2025 02:38:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763375928; x=1763980728; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qap2iRcMcJlDJP5mFPyDz+ljNy7HqlA5ophrRA9mpfE=;
        b=PqEtcWN2gMiSx7W1knC6NZG3sMg3hckJ8B9+HhTVq+jFG4T1E3iZhElpqfvnlvxXpE
         O3Qb6fkq9IJMPmKRAWKcd+ps/ZRtjk+NgjrPrPSbOHe9lmimCJw9WzH1CiolY0k4Io4V
         8lnoJih/Czr6EyY8ALekPSiIgK1f+zQyQZf6ByCadc/Lh2nWEmmUwJ34+vCCD27CIe6P
         ze6QsQJ1V6anvJNulD9dqN35e7x4Vqnk31R2YtSVrq7I/cgKyGoOAqkYJRTNcjQevXLD
         2UwCY1MonQbBZUaidEffPhNAmFmPE0Uu1ex+9HnGdAFmOzLTht/qzSuL9SIDXYX6M0te
         vCsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763375928; x=1763980728;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Qap2iRcMcJlDJP5mFPyDz+ljNy7HqlA5ophrRA9mpfE=;
        b=FGaXlqJwRkYlZW/bbTDKEe2YwovAb4Mr+9E6CcB7an9iAVa/UAC5rfXhj00NYd4aXQ
         I/i3P4qfUrZwVi1ay4etL8RIoSqTfyu1jtFI7txx6Bx2tXf03FY01wsJbAP9BoOzGHpP
         3iPQCU/83nv5ubj9wjeKuGCBWbUfF6WhKSrrr5/GrDXkcWwP4Xk1vBZHm8hcQ6gA3n7C
         O6d/603f1bJ8qjANirBvd/1rKWkclTfyK2KC081cRgygJNobCHtPsNP5sOU476wO1dmr
         OBr05Afn0fnTj4FEdjcBrEX0P3at8eVzuJwpK3tZZQZiWTfT2dn55s6Wj20zCMpxs+EL
         dCOw==
X-Forwarded-Encrypted: i=1; AJvYcCXVqeAnDHSKyo3tRsIZ37c2ky1ZLAXwx6FeN75UHdo5ld3lOtW7IR/+xZNhcoAz/qiuuEOmD/0wI0QSjX+i@vger.kernel.org
X-Gm-Message-State: AOJu0YwMhzji5CBz2YAippWupY8oW2Qll8A3SMAehI01str5rFfF8kdT
	tFUq82pbb03TMqX6UnLbHRjoOrkFgd23Pprcj8p1Mjg3SxUH4bwpskQU+Qs2mFaIkI3APwy9oba
	B+FQqzc7sAG4J6uHgmXYO0IivrQMekNA=
X-Gm-Gg: ASbGncsPoWLHBnzZIKlFEkwab5rh5VbXYYuyLaPu9y7OzyrOsMJozHte3l4fZ4ZRAcN
	q/q6simGeud6v3eP8QPxCxnK9t8Nwg9ZdiSYVbAY6P1PhPPpVWd49VtRyR5cJsUUL70PKq9ED8L
	V8lk4Efn7+zTNy+kVjJNMDOMhCUg2bDX6chRcGgCCb6Z4WxB7xZn4goxu3VDirwGLSVoQIP4Ci1
	2ZnTYOCtnSGjbfnZoiXFX40CRk1LMCHSMPdH5Iw189NMELQRzJQsayba/WpxBC0pp8VOTBmw6w/
	QTBkNf/YSjKEFfOHOw==
X-Google-Smtp-Source: AGHT+IFQBrieEzXt0BFp3NtQPrxoZm9Uol4G2t8bK38gMdj4cbpLL4aBaSCTVB54vvBgjrXba3gJvKXjhNbhaUad9hA=
X-Received: by 2002:a05:6402:4404:b0:643:4e9c:d165 with SMTP id
 4fb4d7f45d1cf-6434f81d559mr13217935a12.5.1763375928285; Mon, 17 Nov 2025
 02:38:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251117-work-ovl-cred-guard-v4-0-b31603935724@kernel.org>
 <20251117-work-ovl-cred-guard-v4-35-b31603935724@kernel.org> <CAHk-=whrCSbimz8jDhh+q8AJH2Ut9V3dgyLxVotn3WLCTyoN4g@mail.gmail.com>
In-Reply-To: <CAHk-=whrCSbimz8jDhh+q8AJH2Ut9V3dgyLxVotn3WLCTyoN4g@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 17 Nov 2025 11:38:36 +0100
X-Gm-Features: AWmQ_bmPS6llwzEBn2g7ry1ARvOA718wT0t_asNxjxv1iSyU-WgosyxIeDa1kRE
Message-ID: <CAOQ4uxhTUZWUjUakUGzWh57iBKriAXqizBCPem3-7+Ng_Urgkg@mail.gmail.com>
Subject: Re: [PATCH v4 35/42] ovl: port ovl_rename() to cred guard
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christian Brauner <brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2025 at 11:30=E2=80=AFAM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Does this old "goto out" make any sense any more:
>
> On Mon, 17 Nov 2025 at 01:34, Christian Brauner <brauner@kernel.org> wrot=
e:
> >
> > @@ -1337,11 +1336,9 @@ static int ovl_rename(struct mnt_idmap *idmap, s=
truct inode *olddir,
> >         if (err)
> >                 goto out;
> >
> > -       old_cred =3D ovl_override_creds(old->d_sb);
> > -
> > +       with_ovl_creds(old->d_sb)
> >                 err =3D ovl_rename_upper(&ovlrd, &list);
> >
> > -       ovl_revert_creds(old_cred);
> >         ovl_rename_end(&ovlrd);
> >  out:
> >         dput(ovlrd.new_upper);
>
> when it all could just be
>
>         if (!err) {
>                 with_ovl_creds(old->d_sb)
>                         err =3D ovl_rename_upper(&ovlrd, &list);
>                 ovl_rename_end(&ovlrd);
>         }
>
> and no "goto out" any more?
>
> In fact, I think that "goto out" could possibly have already been done
> as part of the previous patch ("refactor ovl_rename"), but after this
> one the thing it jumps over is just _really_ trivial.
>
> Hmm?

I agree. We just did not notice how trivial the end result became...

Thanks,
Amir.
>
>               Linus
>
>                 Linus
