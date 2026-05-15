Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CF6331214
	for <linux-unionfs@vger.kernel.org>; Fri, 15 May 2026 16:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778863190; cv=pass; b=UcxM5X9gV/SD19aJLKwQvEK+8IEkg1PS1//IWPLxYi7LbZAtYieooC0lFB4JVM5Ou7rUu+vqZUyJocvw9ZAv45rQJtrusQMRhSDg3Uv1AQuVu6r3zOAbn6a/3VWtZhHhpVbZH38CwnkJyK/9NTWtBPYYcT3x1E13HX3J5uzVjP8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778863190; c=relaxed/simple;
	bh=X0/FYBGL2UFez5gMIokAoweUxT0r42Cl4VVd+nHXcgY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n4cxxFz5XWxdY72+dfWKO3eB6pNW+lgDMOJZIn2iRQk+WYHk+Ne7nL3YhUvFjn2UmqvLntczXdM8Oz3f8801pQRlNNaId7AkGtkM5ND83bTPOZLGEtuDNsMjb7F+dCfs2L40A9G/z3J7Wx59vmwtodVNY/3U3QcmoI951ay0E9Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q1vsM7yZ; arc=pass smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q1vsM7yZ"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-bd21ffaca79so245525566b.0
        for <linux-unionfs@vger.kernel.org>; Fri, 15 May 2026 09:39:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778863187; cv=none;
        d=google.com; s=arc-20240605;
        b=Pyjf9NZPALoGKRoJ1Su2PywicuLvD/nA+0FrzooxeWVmcVgLLIDRxUXZI9BjJApZQd
         IP6R1+5C1Y4VJAjVv8v2a0tmpaIFsuDA364OiGd1d0UN0+u82WeHCZm+eSJuLO7FbRdV
         w8fWjqx19pd9pJPJEKzWKBzMhLZ3nQXEY/J9lCbmzSRhwWk1+X5WyWhgEohPQWlOQ78m
         84xeMlrhOwxNQXptI+LQ+fe0niHTK4GZwscGg8xNsKKlwZKTn7kOctrVd+uMCfaQAHzn
         XEfVWDOSWpdxLqth5KsjbQKztEipj2DnWngD2ujcVbBTPtciuRQGMrgWr/vU3QF4VhV/
         UAfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HlWb6KwLW1iKWT50I5UpGmZm4onihoatH6gRlOACLtE=;
        fh=/Vt7uRkYHMrORTOmtw32UrcIT4bmOjrKmMEzgn6a7Po=;
        b=iS4gwn98Qb0xwxyxxHU7q6IItdgDvpc9wSgpICfB8NTEDPeOtX7Hh1G00Nymk1g+9O
         N9oGGtn4jC3tsDHQjqFNE17Pb+/htiXORjryiMg3emkm2LQM4xbaDmmLJyOh5l/Qr5DH
         TuMgLlMNqMeapC27T7z8RTtESHIK76+0DBIyWjjJ2frM3UQXYdautbkmCknl5sl9SbJh
         MgJBX70v8nA0/gu/HEmyQOAhD99ohujsNhL5fXbqHfqxzCGIZh2KW7Zv9MV1TbGcP3yY
         Fm2nMJSDlIOKFTk9/Y2GBYy/6D0fyVtDWYguzwIR3K7/SFgSpwXinEXW0Wex75G2BkEn
         z8sA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778863187; x=1779467987; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HlWb6KwLW1iKWT50I5UpGmZm4onihoatH6gRlOACLtE=;
        b=Q1vsM7yZxLHYEQv3w/EEOAQww65tVjgvfXPr9rpionyxK6P+si+5j4AtNsk+DHq/C/
         1fliqDaK1XJVeVzsRRGOxFRwQC0SywQTz/GLBRqyVf/LNyK0XSWit7kidBEgPxK0Xtgv
         u9bZR7Pjon98keI+sXblB49vzznxT/QCJOTDJ15rI605la83nN7nONnqzT1VvVEPUQuo
         tabedoD9/FY/lki55kCt/3gOwfSVDu+GRCvcWy+vpF4fjfwfJ/8TZHUTM14jbuDwZgL+
         YzSL//uYQ0TH1CGkd0WUna/lYBKO4wNzcWY2b081z91sna/vjyx2jKsgVBp19eZBqk8C
         zgPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778863187; x=1779467987;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HlWb6KwLW1iKWT50I5UpGmZm4onihoatH6gRlOACLtE=;
        b=oh1ZpOdj5dIMWPePcUPwXBhgYYc4HWDdOeQnKgRsAq/PdDuj6cGNhbhO4Uc32La7cP
         uPXOvaGfMz4n9jU5c5hYNKt0Jyvbx7smUwNOmlZfmD2iaNFBA2imfNq+4TX6rUn+bP2L
         dlhA7S3Iza+x+l7qxmo5Wz0F6BWTmK53A9H7VZWd67QSIyJkHVR9aBHkCeKK9+DlOn1X
         zJBUUlyG3CnsQiGY2+d0BfUfapzcMWveJYV8f9FT3YgIQKjEpR1ynjtO58gTP56QupUr
         f3xvdwJGkBTgD9xxLwTTvYQJq0bosVJlhoAw0Mdu8qIp1q0VkLrsgjrGWZ+pwUmi3npx
         Ijfw==
X-Forwarded-Encrypted: i=1; AFNElJ/2V4Lgu53mpHh9tQezolMgtvejeHltyZ105slMYS9K61vZ0Aj/oBezqG44bPVE5v1gCvZMyDNBoNLsKzIN@vger.kernel.org
X-Gm-Message-State: AOJu0Yzvo0Z6X37k8Fj0IBkK+cMAY0GiAbhlyNKGhTFqAskKsnYKk3G/
	9V0H08/cn1bfBjECXoOeuldwcKUMd8c8rDzibiHe00UM6i44Znm2SqpWhiIlfizN7arZG7qlg++
	b569r5cYaWS0gmlwtdaTizwYSAvAlMEA=
X-Gm-Gg: Acq92OGSDJ7thGoi+K2rKPDujfTBROenTAFp9bbguU7rkziOZxo4dMX7JjocyaLCrrS
	rQPySjK7piaoKwQ+PezbuG2dquOGsB6TkypEjidg4mXTAJrDtjlICCFsBR10jy13z0tnna/KQEj
	PqtFP8djWaMQQf0ODPn6aHGd/zaiqI4jYvGK8zcqQVAq1HUsdr4tYu2GRudZ/V44jzdr5FOtid8
	Aj1bPPCcDwd2qmKeKdcOMMVoCXD0x/UxMQigaYwkwobMo5CM8aoKPXiKuCk7ontAJ+yJqxwSNPm
	aCaU5u/2/DibAJW6MPUWc55KD2Zg1zRxMiAg+m7thg==
X-Received: by 2002:a17:907:9347:b0:bc7:6336:6947 with SMTP id
 a640c23a62f3a-bd4f32fe846mr479049466b.4.1778863187379; Fri, 15 May 2026
 09:39:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260514111354.3552538-1-nirmoyd@nvidia.com> <20260514144258.3068715-1-nirmoyd@nvidia.com>
 <CAOQ4uxjGhRLnuU_=m=P-omUMM=0F+Mxs1O=zTasVnLdLz8ut3A@mail.gmail.com>
 <CAOQ4uxgad=DE9wMAS6Wn9rrEkOX3p0S8jEhsjnj=Or=_7HsqyA@mail.gmail.com> <20be39e1-8da7-4f81-9134-d748841b3611@nvidia.com>
In-Reply-To: <20be39e1-8da7-4f81-9134-d748841b3611@nvidia.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 15 May 2026 18:39:35 +0200
X-Gm-Features: AVHnY4Lq6JVsCpgqykJC2yfUGTMMoHPOa_7PG3ScFKZu8EN8Pa8ub2vRTeloplc
Message-ID: <CAOQ4uxifua9RvEGJfU0ho28Lkdn_oqS8fBYiyxBC0Q8PWc2nJA@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: keep err zero after successful ovl_cache_get()
To: Nirmoy Das <nirmoyd@nvidia.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+a16fb0cce329a320661c@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 15, 2026 at 1:16=E2=80=AFPM Nirmoy Das <nirmoyd@nvidia.com> wro=
te:
>
> Hi Amir,
>
> On 14.05.26 22:19, Amir Goldstein wrote:
> > On Thu, May 14, 2026 at 5:26=E2=80=AFPM Amir Goldstein <amir73il@gmail.=
com> wrote:
> >> On Thu, May 14, 2026 at 4:43=E2=80=AFPM Nirmoy Das <nirmoyd@nvidia.com=
> wrote:
> >>> ovl_iterate_merged() stores PTR_ERR(cache) in err before checking
> >>> IS_ERR(cache). On success err holds the truncated cache pointer and
> >>> can be returned as a bogus non-zero error.
> >>>
> >>> The syzbot reproducer reaches this through overlay-on-overlay readdir=
:
> >>>
> >>>    getdents64
> >>>      iterate_dir(outer overlay file)
> >>>        ovl_iterate_merged()
> >>>          ovl_cache_get()
> >>>            ovl_dir_read_merged()
> >>>              ovl_dir_read()
> >>>                iterate_dir(inner overlay file)
> >>>                  ovl_iterate_merged()
> >>>
> >>> Only compute PTR_ERR(cache) on the error path.
> >>>
> >>> Fixes: d25e4b739f83 ("ovl: refactor ovl_iterate() and port to cred gu=
ard")
> >>> Reported-by: syzbot+a16fb0cce329a320661c@syzkaller.appspotmail.com
> >>> Closes: https://syzkaller.appspot.com/bug?extid=3Da16fb0cce329a320661=
c
> >>> Cc: stable@vger.kernel.org
> >>> Signed-off-by: Nirmoy Das <nirmoyd@nvidia.com>
> >>> ---
> >>> v2:
> >>>   - Drop the now-redundant 'int err =3D 0' initializer and the traili=
ng
> >>>     'return err' in ovl_iterate_merged(); err is only used inside the
> >>>     loop's update-check, so the function can just return 0 on success=
.
> >>>     (Amir Goldstein)
> >>>   - Link to v1:
> >>>     https://lore.kernel.org/all/20260514111354.3552538-1-nirmoyd@nvid=
ia.com/
> >>>
> >> I queue this up and will work on fortifying patches.
> > Nirmoy,
> >
> > I pushed fortify patches to ovl-fixes on my github [1].
> >
> > Can you verify that the assertions trigger if you revert your fix
> > and run the reproducer?
> >
> > I imagine they would trigger much more frequently than the KASAN
> > warnings do.
>
>
> Yes, the assertion triggers with your ovl-fixes branch after reverting
> my fix.
>
> 9541f25af774 Revert "ovl: keep err zero after successful ovl_cache_get()"
> 1c067d912e47 ovl: add assertions in dir cache code
> 98e3a2d258e9 ovl: fix race between copy-up and open of a directory
> 4f80bb375112 ovl: keep err zero after successful ovl_cache_get()
> 18de6460b6bd ovl: opt-in for fortified ERR_PTR()
> 690bd87e1fef err_ptr.h: introduce ERR_PTR_SAFE()
> 7fd2df204f34 Linux 7.1-rc2
>
> Running the syz reproducer with panic_on_warn=3D1 triggered:
>
> [   55.404636] ------------[ cut here ]------------
> [   55.404646] WARNING: fs/overlayfs/readdir.c:511 at
> ovl_iterate+0x4c0/0x5bc, CPU#2: syz-ovl-iterate/14575
> [   55.406875] CPU: 2 UID: 0 PID: 14575 Comm: syz-ovl-iterate Not
> tainted 7.1.0-rc2-g9541f25af774 #1 PREEMPT
> [   55.408328] pc : ovl_iterate+0x4c0/0x5bc
> [   55.408632] lr : ovl_iterate+0x4b4/0x5bc
> [   55.413504] x2 : 0000000000000000 x1 : 0000000000000000 x0 :
> ffffffffc152db40
> [   55.414036] Call trace:
> [   55.414209]  ovl_iterate+0x4c0/0x5bc (P)
> [   55.414503]  wrap_directory_iterator+0x60/0x90
> [   55.414809]  shared_ovl_iterate+0x18/0x24
> [   55.415125]  iterate_dir+0x10c/0x3a4
> [   55.415365]  __arm64_sys_getdents64+0xe0/0x1e4
> [   55.417312] Kernel panic - not syncing: kernel: panic_on_warn set ...
>

Thanks for testing!

Did it trigger faster than the KASAN warning?
I'd imagine that it would?

Thanks,
Amir.
