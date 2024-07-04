Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186211AC44B
	for <linux-unionfs@vger.kernel.org>; Thu,  4 Jul 2024 11:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720093110; cv=none; b=u+ebPpB0hUNavaON5b0hF8FNUX0YmNQzmkKWDWu+6/HMliWxwDbCk5himFnkN2+7NlXxe0D+U5/7OXn599wU3rhNv+kY/Ufb52X/6EHS7P/BwabJY3BmuKSYM28F8TiL9x9w1LX7y5bGqGDDxbUEyI+RlbN5znWCLjfC2vMS8QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720093110; c=relaxed/simple;
	bh=2vfae5AVh3uzOfCNBj8bCXVOkkTVs1idCG6y3/2ugCA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m8iPMJ2S82oXqn4Du9BU7kQ4clIUq0KUmnxQkIHwd57kK2alVdjBb56gl02W+3mysxAYw7ofQ2Hq//OrkmZZ6WuiCb8HJrVZtB0K5Dsgn72T+SHf9YZxf4mZXwA1bPJMsiqKrmyv3xM/Hlg7DIszCIY+lsJ8Lzw/QAHLnWrNtQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L6gdvJ3b; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L6gdvJ3b"
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e035ecb35ffso523143276.2
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jul 2024 04:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720093108; x=1720697908; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ju9HvDVAwXg9Z91Pgi8QmBa3AZ7IHQd6MakaMPP0+xM=;
        b=L6gdvJ3bD27k66iAJSbvunYTHCm9Lw+qVC+c8qyQnI/+cULnTXBD5w3cNPREVL/e2Z
         wJP/tZGRVjxhlorhiDps8yKUskBUUqagipP0SauNWvNiub4jQMf7kAZzAXsX3LbLqRJc
         XbEvS4qwv674Z0Bk2XFg4LOiCwo8cr1TTg7VtiH3/QSvFThLQjT40JBRzoJYIurM20Nt
         WXlwCk5Qn5cubhU0GZjH9yuZn7SDFJpclk1Fku4FfjCIxHFhAm8+YeT24DEQV6z5Uq9C
         T7gg/MElVE/8mFpQZTbC+0PcuyQkWc/Qs8lvXL8YE/hDMbWCD9ds33uY/bjCbkpbJYYe
         vdsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720093108; x=1720697908;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ju9HvDVAwXg9Z91Pgi8QmBa3AZ7IHQd6MakaMPP0+xM=;
        b=hwHMZeFBt0fioIa3zS5EEXjyfCho21w//6ozAvtpOnfpBtf4d09wel3HEFPiQiP/QL
         R/z0T/AxwJ2KsNIkcPehlqx/XRawjpfwsW7n4xllbLWMwCyRRRf/ao3IAz/BgTsEzP8y
         0YMhAalZ+/7OEvwiAPCZf1+LLTiOzNvrht8mcOQg/hyWcIJ4ly+phbuUmhaMJqE/gVqT
         tWxiRonQ/EUJ6tyTQVIgOwtoaHgRddfP6b9v6u1Jm8Dd2rNBB6wDOPbuvBMzv6Pa/d25
         iGMhzKG2y1NMz3Nudw8XB0o/dgNBJIm2iMg8HseoudZs9Fm9QHVvsA8VN1A6en5Xahd4
         qmVA==
X-Forwarded-Encrypted: i=1; AJvYcCVEOuxwWzIY6gVQ5gnO66S8o+9CnPYMZkogvnYtgVfZtQOA3qU1IzJif3HTcQhDuYniL5xA7652n6zsAecv54H8bAzS+Bex8royFOjowQ==
X-Gm-Message-State: AOJu0YyCjJSDP48fsMaSIVd1eO5FqWPhFVtJpNbH0Bk8BOJyv9GMJti/
	eIB90PbzoHnOUq0S4WtBEtn61sbERexc2srdxzQsDueHIKeiZamau641aWMTbbVjgIbfu9Dap+8
	UKy1X2pWHN3QcuQpMCT0pPwoHwLw=
X-Google-Smtp-Source: AGHT+IG3cMDSY+PMgiF7abXoSA/ix1qaW3gv9NW5K/8OKxrPqwK+vQJ3aH3eAV6nYvzuEFMVINlfIon3jEfYbocWDEA=
X-Received: by 2002:a25:2649:0:b0:e03:536f:5e8 with SMTP id
 3f1490d57ef6-e03c1b6e14cmr1245780276.62.1720093107977; Thu, 04 Jul 2024
 04:38:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240703044631.4089465-1-chengzhihao1@huawei.com>
 <CAOQ4uxg8YvWYobbx5ztjkw6ZnUVgv1JDWFYq71HQ5O22=jYTKw@mail.gmail.com>
 <20240703-maulwurf-beinverletzungen-dfb0ff663d78@brauner> <CAOQ4uxjhc2f2D68emH7mdBBa4Cut7R7AjRASkDS9GQtr3MPEHQ@mail.gmail.com>
 <97933464-378c-7158-141d-4b912254f6aa@huawei.com>
In-Reply-To: <97933464-378c-7158-141d-4b912254f6aa@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 4 Jul 2024 14:38:17 +0300
Message-ID: <CAOQ4uxh_j+d5xgp6vWwcN4qTN9dnxbgm09Dp-n=Re=15guEcpA@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix wrong lowerdir number check for parameter Opt_lowerdir
To: Zhihao Cheng <chengzhihao1@huawei.com>
Cc: Christian Brauner <brauner@kernel.org>, miklos@szeredi.hu, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 4, 2024 at 10:25=E2=80=AFAM Zhihao Cheng <chengzhihao1@huawei.c=
om> wrote:
>
> =E5=9C=A8 2024/7/3 23:18, Amir Goldstein =E5=86=99=E9=81=93:
> > On Wed, Jul 3, 2024 at 4:48=E2=80=AFPM Christian Brauner <brauner@kerne=
l.org> wrote:
> >>
> [...]
> >>>
> >>> This fix looks correct, but it is not pretty IMO.
> >>> The cleanup on error is much cleaner in ovl_parse_layer() -> ovl_add_=
layer()
> >>> I wonder if we can reuse some of those helpers instead of the current=
 code.
> >>>
> >>> Christian, what do you think?
> >>
> >> Yeah, sounds good. Something like the completely untested below.
> >> Feel free to reuse in whatever form.
>
> Thanks Christian, it's so nice of you.
> >
> > This looks much nicer!
> > I think you unintentionally dropped incrementing of ctx->nr_data
> > for the notorious case of ::<lowerdatadir>.
>
> Hi, Amir, thanks for reminding, I modify some points based on the
> patches from Christian:
> 1. Use ovl_mount_dir() to parse parameter string for Opt_lowerdir,
> because I found the character '\' can be filtered from parameter string
> for Opt_lowerdir, so I want to keep it(Not sure whether it's right).

Good catch - we definitely don't want to change escaping of legacy
mount options.

>
> mount("none", "/root/tmp/merge", "overlay", 0, "lowerdir=3Dlow\\er:lower2=
")
> 2. Keep 'ctx->nr_data' updating in ovl_parse_param_lowerdir(). I was
> going to move 'ctx->nr_data' updating into ovl_add_layer() by passing
> 'Opt_datadir_add' into ovl_parse_layer(), but I found
> ovl_mount_dir_check() use this opt to do some check, the opt should be
> Opt_lowerdir.
> 3. Remove 'out_put' error handling branch from
> ovl_parse_param_lowerdir(), because ovl_fs_context_free is invoked if
> something error happens.
> >
> > Zhihao,
> >
> > Please make sure to run the fstests overlay test for lowerdatadirs
> > overlay/079 overlay/085 overlay/086
>
> BTW, I get overlay/061 failed even before applying my patches. Maybe I
> will take some time to analyze it.

It always failed.
that's why it is not in the "auto" group, but in the "posix" group
to signify that this is a non compliant behavior of overlayfs.

Thanks,
Amir.

>
> overlay/061       - output mismatch (see
> /root/git/xfstests-dev/results//overlay/061.out.bad)
>      --- tests/overlay/061.out  2023-04-01 14:14:58.354052795 +0800
>      +++ /root/git/xfstests-dev/results//overlay/061.out.bad    2024-07-0=
4
> 14:52:44.993000000 +0800
>      @@ -1,4 +1,4 @@
>       QA output created by 061
>      -00000000:  61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61
> aaaaaaaaaaaaaaaa
>      +00000000:  54 68 69 73 20 69 73 20 6f 6c 64 20 6e 65 77 73
> This.is.old.news
>       After mount cycle:
>       00000000:  61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61
> aaaaaaaaaaaaaaaa
>      ...
>      (Run 'diff -u /root/git/xfstests-dev/tests/overlay/061.out
> /root/git/xfstests-dev/results//overlay/061.out.bad'  to see the entire
> diff)
>
> v2 pacthes:
> https://lore.kernel.org/linux-unionfs/20240704070323.3365042-1-chengzhiha=
o1@huawei.com/T/#mdaedba39d7f261cd2555ea6773ed3611c02e7a4e
>
