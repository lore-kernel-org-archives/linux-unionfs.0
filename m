Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1419A14B976
	for <linux-unionfs@vger.kernel.org>; Thu, 13 Jun 2024 18:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718303621; cv=none; b=uemD0MguBV/55DRC+K01fiJj84zw35VChfpuIqJEI4cHAQIdGYGfvBwvaCHsATxS+5U5kCKCpFRWxWyYbT/5vOTiFgz6deCdFmN3peWeK8tCwiKzQiyl2ni9Ve17UftBelMUCdvEWmS1w5h7JkpHnEICMzi0imXASI0UauzvAMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718303621; c=relaxed/simple;
	bh=E4Zt/CR5AeNFo63fPhm/qR5grtxF7jMoWMan1oAN/vc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k9Htbq/X7O7FiDMAfrzl56C8+cvAjjbb8OW7jkBOt6Zurt9/l4tLGHXxzv3E9wSrMPtNlF28/ZDFrdh7dv83Os9yv/rqTpf43qbFbTASvdFS5gJT6gIF+3TvdLqNRUbjw5dOUELptm/eNKbBC8//hG9DCgf1t24JGhc5PVNjCz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kmCYy/EK; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kmCYy/EK"
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-dff0067a263so1556445276.0
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Jun 2024 11:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718303619; x=1718908419; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tlnI5pnK1H3mhvdRQ+fcJ/8EbsH4mNO7svF+5EtQiFI=;
        b=kmCYy/EKINWE7mKrb+EOqHFSIPxDjPR8vCW2lxFp4jVaVYL22BWOT9kVaTLeSFm8nI
         R3XS3W2izJrjcUSlx/rlFL9UKGQYUE0+WO/ZsyOJlSqVP14GfgVgG4eqTXwDrY4ZugNZ
         nXFzyAWgjrlsw6Dg8UL2GQblEeHhQMMgMNEQtdmfzHvtvuE6GZB1EQw5HwKB9UBmto0r
         2eFajqPTKXxMlsN36EIo+dc987+R2jwXASJUE+yPFC9w11bYp3/0jeDnwUffKoSdV7ZM
         qQ7flJsSKwWmKg+8bFR8Vohrm/s3MPLhLBS/vXRD0BkXonULND+N7D6SVG8mgvyaFCYo
         4FKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718303619; x=1718908419;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tlnI5pnK1H3mhvdRQ+fcJ/8EbsH4mNO7svF+5EtQiFI=;
        b=FX0SoNsUxJ/k1W8wrRA/j6uDCQlIwE9/8jaXOzh1ux57LwIOWNLMf+SCnpEuiGY0sa
         DZvUDQlD54GUKWeoOHQqmuuYnB1CWgBBaLgaqrJ9sgxl7COjjHBj+6PkBt74CUcEdTd4
         OCGrjHoyGUD66RXSrCXNtGgB/e1S+7bHu4lmQjp+AHkC+zWYFbg7rHxaEXfjIssW5eGb
         1qqlreLKhKpKmvldzbPpq/jZOqS8DRLRRR2zeN7BnFpbHMukJ3ROZ+XgN4svsTBQ+3vw
         W1t7h9GoX4CuCA5o73le1H/pzx+X2RvLXrRUzAPkrYPZ8XGxLRGC2WOUtdyuL3SpS9cg
         Ue3A==
X-Gm-Message-State: AOJu0Yye+JX9aeoeY6OT/nLsgDHThGaxg9Dd/x2+8kJmVkYQm914+cql
	P8t+L5/hrxxPYePgzXLNistnkST1LEmFpEjsuklouSj91zLgYc/HK+GqytN03eZDnz7gxdIWRB9
	1yy2vX4lkAqy3nPd0njx5uUQTObQ1alIC+6s=
X-Google-Smtp-Source: AGHT+IGYJPthq5EqpT3f1BE89DdRM3606dmPq0TXvKEHvxciq4Fet9/ELEReA7nVFy4Tm6kbEnmR5JxrmdxTts07+hQ=
X-Received: by 2002:a25:bc87:0:b0:dfa:5895:781f with SMTP id
 3f1490d57ef6-dff153c884cmr343407276.37.1718303618667; Thu, 13 Jun 2024
 11:33:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADpNCvaBimi+zCYfRJHvCOhMih8OU0rmZkwLuh24MKKroRuT8Q@mail.gmail.com>
 <CAJfpegsCsBjHNTEe+6RmeLK7jb_gz_YB=CD-RKUWiscG8u+1cQ@mail.gmail.com>
In-Reply-To: <CAJfpegsCsBjHNTEe+6RmeLK7jb_gz_YB=CD-RKUWiscG8u+1cQ@mail.gmail.com>
From: Youzhong Yang <youzhong@gmail.com>
Date: Thu, 13 Jun 2024 14:33:27 -0400
Message-ID: <CADpNCvYu9q4bEPj-xhcUdo4j48EgBCFMst7LNc3Pq6w1d7Xd5A@mail.gmail.com>
Subject: Re: crash inside ovl_encode_real_fh() due to NULL dentry pointer
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you Miklos. I tested the patch, it works.

On Thu, Jun 13, 2024 at 5:01=E2=80=AFAM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Thu, 13 Jun 2024 at 03:32, Youzhong Yang <youzhong@gmail.com> wrote:
> > I analyzed the crash dump, here is what I figured out:
> > - The overlay fs is mounted with only 2 lowerdirs, and nfs_export=3Don
> > - When ovl_dentry_to_fid() is called on the root dentry:
> >    - ovl_check_encode_origin(dentry) returns 0 as euc_lower (I believe
> > it should return 1 in this case)
> >    - "enc_lower ? ovl_dentry_lower(dentry) : ovl_dentry_upper(dentry)"
> > evaluates to NULL
> >    - NULL is passed as the second argument to ovl_encode_real_fh(), so
> > it crashes
>
> Thank you for the excellent report.
>
> The attached patch (untested) should fix it.
>
> Thanks,
> Miklos
