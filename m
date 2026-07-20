Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532E73AFD09
	for <linux-unionfs@vger.kernel.org>; Mon, 20 Jul 2026 09:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784539344; cv=pass; b=jJPhzpAs1aPkCKPbc5IZapXwzYBn58X6OPpO6YMj/0KQw6aPHTXRzqxrH/z2+Epiu1xXcsWq3UMq740BYlSJOOmEcnv2rLyT3TUlc4slz+uumi/ae0v3tH8uKZUc4MieEsW7iCaJCxSl5Mbs+/7XnuoF6v58VuVBgUW9HX9Lhm8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784539344; c=relaxed/simple;
	bh=v1G/U6rYwbjprWYcPlrHGKT0xVAuOYF1UYTXLhSRnAM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kTz5W2RvnmLoB0vudFNW2M0ccsRc6kTlN34e6HkDOq1+5NPRzw7i4bteN1+qb2Nd59R/3LVOzMffKnzgRDf1P67efX9+wNMc3Y97V3PjPP6FTvklaC9rwCCmvcGMNA6drZacZ4Gw8UtbCQB7G9bgMuypEhWt6s7qxsavT05DEjA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=aebP9PPQ; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="aebP9PPQ"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51e4ba1cfb4so53876501cf.0
        for <linux-unionfs@vger.kernel.org>; Mon, 20 Jul 2026 02:22:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784539341; cv=none;
        d=google.com; s=arc-20260327;
        b=b0GJLbrhj96RJ8v5OwO1d8/xeQEPlRE+xlI6cHOo6aPb7GrwzH78k87Wk6MCEEYlnD
         QyN6Tvy9fF4gx3KNrM9cqoWUvIxRqplguzO4qSHGCEMIbf52HZkztwLwlR9nmbLVjPBF
         8vwfDwK09funkMTs7Gm/v5RvEzukACMYjlV/xXBQCJTSlJ2o3ZgPbje+1Z6jm9E8STKN
         vRm9sqOhIAaUh7yQ7rTnEZWhGgK8Nm40EH35XJlcuASBg+UzFstl3Tkf/MGUxnSswIdR
         mpdfDc/JDRoF+98wiCIdB1b9gXfaLG65RLuud3vy0VeB+JLQA4f0esP8LSLZWonhUipj
         ZWQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ip3jHsFq/3cxVMe2s230B81UAfkN7lmSalsLm8p4Mjs=;
        fh=N4YRnxl25PeblNHfjKFB68WDUdRHIYVLQwIUXLz1olI=;
        b=gW6JhvmEWQXSg6i2rm3ceOgo9mxOmqfw4JhE5/ltnRkEPCbJK/zzNqYGv3l5/sZos0
         Ov1CxFXqs/KKEybSwQbGHq7vI8zz76ecyHvLmUN5RLMnF7o59IHQn4GgV066vLke3Fs+
         O5XfVBYE5wKZmZ0CYVyGA61Dusqm9Kk3/ZAQ2N3TTbNbjcu8iFVYa2BDb/vjkV0JHpfK
         RQH16G6LnLkYdcb6QcDOS/0wXmzeZ/i+CsFCFgONCQ2M2Y0VgYelCg6hee7ihA4nHjOo
         pstqYSn7gzXNZy/mwmpaeOY9idh9Hu6TUAH9zPL2Y2N9AKMrs7M14mm+2rluCZWdxa5V
         ZHmA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1784539341; x=1785144141; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ip3jHsFq/3cxVMe2s230B81UAfkN7lmSalsLm8p4Mjs=;
        b=aebP9PPQR5pm6N7/qxL7c65gZmz19yeADLMgDCVbA7eBNiQ1p0LOsj+dZU4dBMjHkY
         TYI/0bXSSPxHqc/Th0TyEqYLJLywLtNWBP8SfWlNyozVDr+V17Dw6OwyV2r5IEJqJ1Nz
         CXeTY+f2ynux3DvQ8s/P3CSutNxD05Upp2Ifs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784539341; x=1785144141;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ip3jHsFq/3cxVMe2s230B81UAfkN7lmSalsLm8p4Mjs=;
        b=e4pIH7lUM8abs/eWZuLoUOVmVbd/kMoWDMlu+tlBUTFkGFCcayokcd2YH6XElgFgVf
         w/6pwuI1jFpCD4ShcoqenOkOWFNM33i2HM22ZVOiwZF80919NQU7Oe7l/LjHpd3suPkR
         Q2z8ee3ufxlNMKfmzxRnGpGqGd5EGMsP+XLCWrFDNe8co/jxmK85xhCvQC7MNBADjTbt
         x3HotHV7tQxErLGGCynBq4C9gvubbS3fkDa0IomkVTcSuSoGJ/AxP6J9c6sadpZUFAv9
         PqSZnK4aQtEYFj1jYIGkwK7hHTvvq15eMys0EjRiiW2U09qYfX20ZE6FS4FcEs9988Ha
         LPJQ==
X-Forwarded-Encrypted: i=1; AHgh+RqilNOjTm9pQGZyheG/A1vzWpPBh55hrOw9Q1YmTevM7S8K5KWUbtg/nxrpx6CxADN7JYOB929lTa+ZBfQ/@vger.kernel.org
X-Gm-Message-State: AOJu0YwsFeD/6yuZtEX/MEfxc9PTpiM6aRRr3ksqDCfp1/wRD8vlTxUV
	E2c4KNw7zCfW/mtN6yAc5wFevYjxe3WYZW+UPFQ9BSjqWDY2muxgCiF6qvzj2IIUGcAYDbQaRom
	bcuwrIriez5PdWJrhcA0FaW/PBTDpwEOi2gECn1aM3A==
X-Gm-Gg: AfdE7cl3DYdB9Xz6gZvcC3YfqmJtCwdNQ7sMKlnT/gWv7ga2p/xrvUP5dOPxMfh4CE6
	sIevjkYB82UAJDPNwIaSYvjw+margI7rm19Qa7Jka1xCgGfdaPj509Vu+eEn1p4OB0x+gjWRU5q
	2JCcaMDo6+EsM0Hh9wAPpoauPUaH1O+vutdw384BuFkPZJittC4i12wVMyCJGBPcalquYtvK8G9
	Css471yvw/0CCcDp98ZBqCGLOlMxFQ1jhxyZjJzovHUZp4eS46+30bNT8teLSkATmIkYX72UqV0
	L24e/msoNb4lmLD3Hg==
X-Received: by 2002:a05:622a:1192:b0:51a:8c9b:64a2 with SMTP id
 d75a77b69052e-5213d0c7ca4mr116936831cf.70.1784539341012; Mon, 20 Jul 2026
 02:22:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715101107.973997-1-mszeredi@redhat.com> <CALCETrXYHX+OSwm6vhzQqvdk9Fkbxzh_dGuVm2tjvPJG_x1XdA@mail.gmail.com>
In-Reply-To: <CALCETrXYHX+OSwm6vhzQqvdk9Fkbxzh_dGuVm2tjvPJG_x1XdA@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 20 Jul 2026 11:22:09 +0200
X-Gm-Features: AUfX_mz0IN3hn5QumsNu3idUZDFLnqeEUQTN9zg17vrQKR01GmrNXzVy6O1zEgw
Message-ID: <CAJfpeguxCOw4cURjPVOMj5-A7JnLrmy8zx4qE9uwxg7x_Wr+zg@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through O_ALT
To: Andy Lutomirski <luto@amacapital.net>
Cc: Miklos Szeredi <mszeredi@redhat.com>, Giuseppe Scrivano <gscrivan@redhat.com>, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	Amir Goldstein <amir73il@gmail.com>, Gao Xiang <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"

On Sun, 19 Jul 2026 at 16:13, Andy Lutomirski <luto@amacapital.net> wrote:

> This gives me the willies a bit.  It's very cool, but it has some
> potential security issues that I think we need to watch out for.  As
> sort-of prior art, NTFS supports alternate streams and Reiser4, ahem,
> supported files-as-directories.

I realized that we can keep the creepiness factor minimal by
introducing this first in procfs only.   That way zero changes are
needed in the path lookup code:

sprintf(buf, "/proc/self/fd-alt/%d/%s", base_fd, alt_path);
alt_fd = open(buf, O_PATH);

Thanks,
Miklos
