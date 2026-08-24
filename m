Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A493F0AAC
	for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2026 09:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787564981; cv=pass; b=FMHFSYqOPyvACiURNx+N/ODZTaPUeqfa/VdBVeETuCEYAOPld0t9qyJhvUnoK9HTdMYcnOacOgQcTMtmaTJ4fn3/ypX/9M92tvf1JT1wgucMqfnAEhsUKV0lnffMWiIBGoJBLkcjup7sdN3hpZaTBgLgcUzM7VS3ow8+l9lhbms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787564981; c=relaxed/simple;
	bh=f7zLB78qgfsXeXkJUI5zyv241QNeBkiTpmVwCFsdDjs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z3GfoVXhqY2nFi4ZUNW9wwU7Ab4gfriimrMGFNAYB2euIOp97p8YAkJBWnskg9QvnbwF2lgtMZMLBxXIWV0W+nkIVNUlCt1L08CvCCeh8nwYuX38AdWyvavS8PSS0bWF6gFx+2XODk1MVhlgHq5ZYDsqfQbqoz9DV1PM54ZtjQA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=hpfuzpH7; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="hpfuzpH7"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51c05dcdf49so31220601cf.0
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2026 02:49:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787564978; cv=none;
        d=google.com; s=arc-20260327;
        b=YR70kQpMnJFs7R1BTTLVCwfGv9pfcobGVM1oP+x2VpUYo8AXd4RW7+fdmsIq9lqUwy
         OtoY6z2JNavWqfv8VZzqIJjIQCGhSCTqoFRhaGD/QUaA0Fp4Qt+euLw0ZfiSmji79sAz
         xFRGLL87e3Kjsh9LimdhR4e9Pw5hb3SGuxMGm8f9mPHq/OGeWCfiQ9E1rdlN4UyiLyYI
         GS3GY6vBKug6VzMl65Iw5Y2Qtw+8dA1uAE1MkwHrQqVVVHswrgIxttfse5DVsMToQEvz
         Se5upIfyFlgMJ02JmsEpKTY3QScmrEw5cdFKGvkQ7QSLs9DLFzVgVK82a/BYJokpfyh2
         NWYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=iqA+Vodt4zn8f6pvRuFDvrg7Iu6eZrCLtVsfmIZOyfA=;
        fh=95Ja7QakkhaFw0cGQDnyrjKWYrTwinAohB+Q2ygFJ9s=;
        b=YYeybUZBi3BpQ0JHj1bAHG6EZGSb/s+9re8dzTEyWkzXmuEADR7msWxLuFTqtXvVx+
         ep7b8Ql2M2hHDoM+Lm0/qfRIkkGVCYSqMAoPjT/OJvUIFUjVAT3Li+0fskpnTAhsBAFr
         NbJzhGhbLPS5voMuxQLfueazCfDA67jmouNHVWu7If2Vy0/7D1e6om6n1DxahMa95+N1
         hg15TlDTzI5ovFyVcNk8Iq8N4SQJvptC6f94yVT8szZGpoWhKoR5cbnp8B4pfqT72cWf
         XGYKmS5zCvZ5s/Nwk5WiciuvfDSkq0J4S3qrYz7e9Xsi/PeKws17l4gQ2eT5kOKKLWOb
         GPaA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1787564978; x=1788169778; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iqA+Vodt4zn8f6pvRuFDvrg7Iu6eZrCLtVsfmIZOyfA=;
        b=hpfuzpH7dAW0uvOb7Sy40AR3iosxCENVFN7yT033bC+A8maLH8sW2y0Xi3sqedpHOo
         ymxDdbU+xjNr18fPiI9pETto8k2B7MlZXD3SKMz/aw5cZFTjc/xSGJMKIa0n5d17+IEi
         i5ViHUqI0lsXVaGvSyqDa84G8QMmAAQj3aGS0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787564978; x=1788169778;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=iqA+Vodt4zn8f6pvRuFDvrg7Iu6eZrCLtVsfmIZOyfA=;
        b=XvrXar+LdPKL6SSDs3po3uJS6IfH9VlAisZ15REIulfGZgV6HlR3YD1U9CaoUnGMcu
         j2fUrMEdW1Nx3h64iI4/T18wdHQCXn3poOxq9rsKIOeOpNv869QxoxttASgjE8cYogu1
         TxdNLo8QCuWjRoVozy38knFO8JLHJ+QNOYQQxRFdJqu9y/ZmHEs7R1/txu7itbPiwdfa
         48JCt5CnPcM8LDlzSVeFHg+AflweIH4NkzjD+i1G3AXRaUWBUrzzUoYCmhtjVVPRo+6i
         52fpEpE9tKZqh/uw3FRoK2OV92tJpBFine+eW8DJzrI9Ap9yKbJZoh1yHcj9IQhmN4Z5
         IKqQ==
X-Forwarded-Encrypted: i=1; AHgh+RoxNmGGEi+95/VDwDGnD90sRtRAiec3ywuN/b6PFj6qVcL3bP8kOaWc6eugprfhRTAMwQJgW4GxkGAc+eQF@vger.kernel.org
X-Gm-Message-State: AFuF++nEEnKPtSj5eCkOrg8/zLxxtCrMO7Cb5YQB7MnsPGs1BLwGY9UL
	nYVIlHFl6LQhL76zcE05gRz3hcc4eojzq+OjQEMmp6Jf/JYl8wZCq0BCoqDlZ1o0ExhKdIsO71c
	Auyu0qaAHbNhsQj1w/eLa3AMubGpqzSR3QNoYXRhb8Q==
X-Gm-Gg: AR+sD127DsVkDXtG+j+GtEtIiXDCvF6gC1pQ7cyWFDRA75YDQTAYfOSoII+sS7HSmdX
	m4d+io4OyuwoRAdY/w7dH5Ztl3oB6x70VT0uqjGiLdnPsIe5I90Sl9rnmZN/In/kpejRklOZYyh
	pS1QxFHsFzRBf+PmiM7nQ5Xr/ZaUue6Hf4zRiN4lA0LHFCIy8wxBq8qHQeV6dCML5oSehdB+ds4
	3Sg9E+2cV5+S2iIqgk/Z5sktyXJgj3V/b1C+XE/hamIO8WHHwV/0ryxuDJZC7/vip1vXQaUqa0L
	JnjOy7voW3mIwJr+O3H37ThLwT9rVNH+LT3l2fvtw2RP4I80I0Qk9feZJUQfCZjEXONubtCuBlg
	bZfY=
X-Received: by 2002:a05:622a:314:b0:51c:981:94a6 with SMTP id
 d75a77b69052e-52e09cabcedmr166055741cf.23.1787564978195; Mon, 24 Aug 2026
 02:49:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <2026082150-autograph-perky-e3cb@gregkh> <20260823224256.2724025-1-fahad@codepure.com>
 <CAOQ4uxjhfpNVvoVrTayj46H2CViTOc3oxzM6xdb8+E7ikE2CSA@mail.gmail.com>
 <CAJfpegt1WinKmP5nOGv8Yx9VLf4Mk1ojg7e3xR5iUz=7yDAh0Q@mail.gmail.com> <CAOQ4uxj+GRa8CaCONwPQzLCjx=R8MRr6PTYYC+QW7VrK0PEhMQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxj+GRa8CaCONwPQzLCjx=R8MRr6PTYYC+QW7VrK0PEhMQ@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 24 Aug 2026 11:49:27 +0200
X-Gm-Features: AcwNN1XHPbV5W42Fv0eyXcWCG_2PycHva_vfR9-O3H1AMlqLqtB39n_N9b-Q5EU
Message-ID: <CAJfpegsVoUyqy0dYkTvBGRZvgdv_nmzmCw_uF+LP-Vq3EhEkSg@mail.gmail.com>
Subject: Re: ovl_copy_xattr() can write uninitialised heap into the upper
 file's xattr
To: Amir Goldstein <amir73il@gmail.com>
Cc: Fahad Alharbi <fahad@codepure.com>, security@kernel.org, 
	overlayfs <linux-unionfs@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 24 Aug 2026 at 11:30, Amir Goldstein <amir73il@gmail.com> wrote:

> It's not really a retry loop, it is an opportunistic buffer auto grow
> loop, see
> e4ad29fa0d22 ("ovl: use a minimal buffer in ovl_copy_xattr")

Ah, okay.

The logic is too complicated, though.

I'd still go with a separate helper  that gets passed (..., void
**bufp, size_t *bufsizep). Single caller of ovl_getxattr_value() can
also be converted to that.

Thanks,
Miklos
