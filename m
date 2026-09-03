Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BE53BFAEE
	for <linux-unionfs@vger.kernel.org>; Thu,  3 Sep 2026 08:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788422983; cv=pass; b=iofSfFBVpSxchUQeYiXgfK4Pdl605hqRZVoznvXark4swdnGa+FDhq0n/abJyK5hkGx2FlMNpRhuQ1qJeSQTymBXEofThLEfx7Al5aTmjOcEwKkCkz3kXLAGlTKII4LeMw0Evg3Q5KuJ0zrwTkd5keYL3InMyCSlr/3CX8L5VbE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788422983; c=relaxed/simple;
	bh=GE2V7iGy1lJ40QSGCJ1aOi34U1nb6hDAIOvSeMgLVLc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LZszJpyLO1K4VFhgBhBmNWE+Nf6NCyLnb0d2RR0L1rmkHKW6kYxE0EYXZ9g8Q6605Ycu2+vJKEhHuKKWW3TLQB9KMNrfS5ctswc+5eFDymljOJ72wilXnJnLMeraUfAqMpzTflL0jMtNXbdUKMVRRIzwCeuzjl8T4LXCEalNUhE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CxqITsm/; arc=pass smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CxqITsm/"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6a63667b78aso3592125a12.3
        for <linux-unionfs@vger.kernel.org>; Thu, 03 Sep 2026 01:09:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788422979; cv=none;
        d=google.com; s=arc-20260327;
        b=l8AHH2rUYZuq1EhymUWRfzb3sMopR5jN5YEcDRG9Kfp97toNF7exyeT0GmzJTzWKPA
         HXILmQMcVAav00G9cxweTQJ7Ptg7y2dKGvg+mGijrhk14h+vrcN5BsNB9j7B8GMacuck
         8J6OWneqqazTsiob/fJmJ0bFVmKgMZPyrHpjYg/hg2FRNevbM3OTs0ZMMI4ImWC98eXA
         mj5LfQGMmndZP5ilG3W257yyzoeJpB2BN4FED5phWKd23c6lEoq4/Uqz/EsFeDKan3CX
         EasRcThsDgAorIcl5/3ApDccc8eSyKUl2/D7EAreLpL7MvbO9S5UBE8OlmrFam/jI2dg
         BKtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=l7ege4JtjgFHRNv7kt3LuaCil6zWlhJKcEkBUtmR4ro=;
        fh=fE2jrC4dLTBbFbriBpIsDSG6XG5t94bW8GxlWFNrpCc=;
        b=PUBejidosF+MbNLRT5ahbhD/JLEQriM0X7YLbZXlbogF3dwvvOtuhfe9/3+oAdscTI
         k7O3Q56j7fOgwbbibHk97OnO6weXWCaMaupHD7kKGTH8fTT6C1JnKEqMq1hVt7mz3sRQ
         FijkDVNz0+0LcI9XELtXeaHpNNQzYARWcJ5fI3LzUI93hAD85joDFJHLr312EuACD8yk
         DfwTl2OQuDuDGKJiMYhH0GkSaXdaGrxmyrz3izGYI8/L2ctqgdhIviLFAXVmg99oBj1K
         AKlO8WiTY7Yj00gkOZjqLf3Zx8sdVYCCKsGU4A7E2J6/Y5ke272i70CW7wLnO7+PaV69
         bF6w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788422979; x=1789027779; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=l7ege4JtjgFHRNv7kt3LuaCil6zWlhJKcEkBUtmR4ro=;
        b=CxqITsm/7UfBXHbg18bcCPFkfOa6SH/nMvjGYaavL2DH9DmbVSoY8Pf1sl4kDGA0L3
         AOblh3QDq24GfTJNpSvBuMxXHKAzgzjGc2YurPDzSbUAH6wr3lVJosD7yhFbtc7IVm4b
         6JlcK8Pm9L2fDp8O+oBnLgH+XZCxlqnhGNGjVYFqqKqfxW8+ESrH8N2gKsBDpM44ckzy
         cFbGGqk/UkXL3ji2oRSRgfvjUqzn2oYyVfUpQDwCGZ63bnwzsE8H3727/mokT4XSS/nI
         cAKrd0rpNJtv4FpKEg7JBBK0pE0qzOzL1UR6los7tdug2CxlGJYfIY6l3+Rm6EbmdXvw
         XUZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788422979; x=1789027779;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l7ege4JtjgFHRNv7kt3LuaCil6zWlhJKcEkBUtmR4ro=;
        b=H/ForMHYm9RB0bs+s2ghRCXfiph1nh52uhed9sV+qHfetNJ85S7ODTGlyvvdPJT8Mr
         Y4mm8v3ro+RjtQBrZGegsheBcQnNAzNeCAJABUiIsGjX61RnT5pqMNJP76NLE+s9DOi4
         R/0WApuDqk83F+U+0BpNvFznJ1/Gi0f0cMpbu5CcE5VVHs//KWQ66lYgSTrRHWP6ut54
         HAMBd0ldcXdUHNAWQleYjzMv2RIVf9FA1pP4QwMGs6WLtfafkGdVJ4w0ILRGCYRXg8eU
         v2jmW30O2tbIZAgfKoZzCNqH573Nm1miLNT4ToJSa9DZPgG1ZWQVuhTOYWLk0KXdlKkg
         XXIg==
X-Gm-Message-State: AFuF++lhWcXk/u2zSyCmsuhRG6nViagvlr30jsUB3arY1dFwyXDX3Lqz
	Dggd2coQYngZQXOvhxt7cAs4fYqa8SKFjwumHXwPZB5ozksyToAy4TOsq+jDrCuJUTWtfkWxH64
	hpXahvpO0AL8B2uKpa/KeNiEGPiCYJ3k=
X-Gm-Gg: AYBFou1a1PE0tZQOIIFViRDMcGba2zSibzO9J+PbTSCg6TWoY9IZl8oFzMebEN9NDxN
	kRw3czRJhDXsbSgSHn2Z3N9j+LNUJnOUxM1t6fbbpXQkobk/FfgMa9ueHODBbePo+AUALE4HRJU
	cTz34PSf67f/Wd1jK3SrBm59+LFxYl04Fpc8lQqdloMA2S3/FmttGFW8b4Hyp3EsxdctlZ6dJMp
	XkT48P6a1klbHy/aZ78AXVdGwYO9RudgJ6p4Sr7jO37MfQN/qn9YU/NFIm731m1pKUX/+hGGlBJ
	r1C8L2T4+3IoyeomyZxayPCMq8BL+Z4cGTYSXJYIhtD0nXXsXtkdsP7N
X-Received: by 2002:a05:6402:3815:b0:6a6:774e:8a56 with SMTP id
 4fb4d7f45d1cf-6a682567105mr7784290a12.4.1788422978844; Thu, 03 Sep 2026
 01:09:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260903064504.1052841-1-cui.tao@linux.dev>
In-Reply-To: <20260903064504.1052841-1-cui.tao@linux.dev>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 3 Sep 2026 10:09:27 +0200
X-Gm-Features: AcwNN1XMHTJAxrMSsCyIoWLDnNM-q-2UafNwLmU_5tyYTmCFr10VFZDEo8zUcyk
Message-ID: <CAOQ4uxhZOBv93_y4K0mc4PofprdPfSN8c45KW226LR-JO_BEkw@mail.gmail.com>
Subject: Re: [PATCH] ovl: reject verity= together with userxattr
To: Tao Cui <cui.tao@linux.dev>
Cc: linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tao Cui <cuitao@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 3, 2026 at 8:45=E2=80=AFAM Tao Cui <cui.tao@linux.dev> wrote:
>
> From: Tao Cui <cuitao@kylinos.cn>
>
> userxattr forces metacopy off, and copy-up only computes and stores
> the verity digest for metacopy inodes.  With "userxattr,verity=3Don"
> (or verity=3Drequire) the mount succeeds, verity is advertised in
> mountinfo, but no digest is ever generated and no lowerdata is ever
> verified - the option silently does nothing:
>
>   $ mount -t overlay ovl -o lowerdir=3D$l,upperdir=3D$u,workdir=3D$w,user=
xattr,verity=3Don /mnt
>   (mount succeeds; after copy-up the upper inode carries only the
>    origin xattr, no metacopy xattr, no digest)

If metacopy is disabled, then the data of the upper file is in the upper fi=
le
there is not supposed to be a verity signature for the upper file data
verity signature is to attest the data of the lower file, so this report
is strange.

Moreover, even though metacopy=3Doff does not create new meta copies,
it still respects existing metacopy xattr, which may very well also contain=
 a
verity digest, so the statement "silently does nothing" is inaccurate.

I admit that user xattrs for verity digest is an odd combination, but it do=
es
what it is supposed to do.

If you want to report a bug please explain how the security model gets
broken.

Thanks,
Amir.
