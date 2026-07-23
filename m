Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30894A13AE
	for <linux-unionfs@vger.kernel.org>; Thu, 23 Jul 2026 13:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784813809; cv=pass; b=pmyhtwOQrP98irk+zKXkHK+GNbLtWY9YjBZbI4M1yI2FmmZ4KgfZgeQMYM6PVb9yssqtysm8NQGsFpzdyBNepfHUPsL2aEcYOInZN+SoWeNAhwCQmr7gTPp4x6fy1/kY5yqFK1vfLTXCJ58QCdqyKrnLWrnPm7Zqn3GgqxFm/Wc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784813809; c=relaxed/simple;
	bh=1hDmEyNzjOlJy44GJhsNgpUOmcmTUW8/lfO1ur59H4E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N3XuKOP4mEoPgM6GUYLGYI5CLCXQzBiq1iDqQRBd3yaWQanRc+aSjcNDbVK44dkg7xRYn1LgfughwL5yo9WsPoiqJJf199bMn7a8MZOozbW8KAZf3fKXj1SPJFk4d+tFirDQSxtDXSpQM2Xc6maqUotSjF2G2GsGtE6RSrYQm3Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OBGuBJws; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OBGuBJws"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-69e2266b07fso1012607a12.2
        for <linux-unionfs@vger.kernel.org>; Thu, 23 Jul 2026 06:36:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784813801; cv=none;
        d=google.com; s=arc-20260327;
        b=UKQDzypjLz82WUGpjHyLkyHAJcR9YkDSZS3l51gyJi3ca6Xxk7t7cc6kD6LrUJ3xYL
         IJum7QarNZ0V75liyJSnqOys5DjFhvSO91jjuvPsx+zRGhow4WI/4+l3FTQrvlRslrPX
         ekOI2YhIP/W7yW77rGj1QikL7RXcyZwIS/pnXlPoaxn6y6MT1CYSoBwSVx/NsNl+wA35
         38FzHaXlJfgqG3QfWsRH0rdSboq5n65ynJIO4iDzxqfnOMfXMx1UpOhSwZA8N+T+ok3l
         qR0XjQBuOA2NCGMrEPas17hauXXfLN2Wu2j9EkBbxiH1iRRGaTnSiRbn9QGqg9QFJzSJ
         yJyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1hDmEyNzjOlJy44GJhsNgpUOmcmTUW8/lfO1ur59H4E=;
        fh=5kEjMpOfgBoq4wUgyyRRJ62kfNiIjXU/6zsTgKDhKUc=;
        b=iMfC/J7TPRRjav+FpKfLid1k123iMCm+FpUUolknNDoB21nFJ0gZxXjk2ZPWtYgdlX
         uHnZw8QYBmUf/HjfBeJCnB8NLQoMN/4rmSByBn4KJAhgcrxwTx4QFojVReKVTsM3lLgL
         6Pg1QQq1d0zXPXazXWVGFM822QGgMWvE7sw1z01WB99WelnY5cxe/hPqx8v8kZ9rGt7e
         Nxh5LIBQTbi889cUH0QZ+6wWkl3TIvml5aKLlPadbv1/UBR7+9XK/sbmnYgM9QEOzXmC
         RIwA2ldtGDFh59QHKJfOivEYWme4uTcMOUEGJ2+XRSZkfZ6Q1CJ4rlJGiANf2nF17h2g
         +3fw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784813801; x=1785418601; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1hDmEyNzjOlJy44GJhsNgpUOmcmTUW8/lfO1ur59H4E=;
        b=OBGuBJwsOvZ8W2EHkFXJ2Z/c5Czp9pEIWMfhEJ4JhF5FyDsKTQvaq2xZB/zKZG+z3y
         42v3oMCckvC1B7LcB7VTM95bxj2BsBEqKzYCLfqKEcxZkeKGs4i+L0GpV0hZB0FdKTxD
         FXXegTAOvnvNvz5tEToBKw8marDVosdefl7QKr5ftQgVN17e8T2FhrSKplxlw710vb0N
         ap8kdoPkz/7tI9oY1OhiuyjorcXkuowE0NSIyNuPy6NBfE7d7Q4TNBMSp9rsJaEg9bKs
         N5ziWjyG5SVb3ZoKzN7t+6EMPO/SaSgd2AFb+kRsndQjmaThV3pq2rE9thHM/qEblRaT
         hsoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784813801; x=1785418601;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1hDmEyNzjOlJy44GJhsNgpUOmcmTUW8/lfO1ur59H4E=;
        b=hJc9enf42Wugb46f1JAgYAdEbkMUuwxlSrBq03w7n0P5ucqSTOEdDkQlQZlpjE5+9k
         WM/N953QzUmk1mlsKzBVz6RIb6L/AjsCSkGiWiw9LBI4J5QtsiFlMCCeh9Rb5BT2bE3Y
         rqLOfcv2UuMylvXD8RDC4V0iDarfzAQ4E5ON8Gf7Ff0WsgKKa8j4d9JHnSDh8q+ps6Tm
         F9hikNUgm85JpWwX7FF87lfnDMpwrOroKjIQKvE/BQEPJN2PoMN4SiFU4MhewT8f1/o9
         i5Rhsdn4KfnI/Mo1f9OMCIJu6qZtkoiyDX5XgSxQxDLgYh7plLGRIokMfsnpruoMG0UA
         xqpA==
X-Forwarded-Encrypted: i=1; AHgh+RrJ4R1THeqiMtJralJ36aZXwIkBTYFkMzx5jTjzjHihKSO85MbCazXZyn7NjejOUBCKSNzz95NcKDg4EQeY@vger.kernel.org
X-Gm-Message-State: AOJu0YwF/ZqTBCi3Af4gve74jkeU1DuFb3+4vWtpcETiqbraQEwz33cR
	VcbL/LZOUWKPi4wuclfKAb7z0H4D5JjjBdlsZv2SQ1E5rwPMv2enLudDSKpoX0GWhSW1Bs8BAcy
	1RhIvDS827+6P/uRgWUxt8RCH/l4JsCc=
X-Gm-Gg: AR+sD11Dk6Esvz2oHaoIpAWo/dGqQjPHEoiT3WhNiAH/m1QFm9MkIcoBFQh2kDRettl
	OupfHS3xqOPmRnA1gI02buygsWcSO8mbB97xHw9si3K+mVHSxATvenWIl2CkacuFxwJRaUcLHw4
	YDhByCYQmR7eXakTkJ7btt2CSK8axv4Z+uY2sG1gaqZ5uloo3GFOj0XhaKoAEAtH8CeVn0my9Gu
	HwMAcMWluI0wO2x/a9R4GD+Q4xGYo3VItB9WaLhM/elWQhMoAG0t0yAgUzxFpe+UG3XxfeMFw==
X-Received: by 2002:a05:6402:510f:b0:698:87ac:33c2 with SMTP id
 4fb4d7f45d1cf-69f6b142efcmr1180945a12.9.1784813801039; Thu, 23 Jul 2026
 06:36:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260723114848.1212429-1-amir73il@gmail.com> <CAO8sHcn=b94SL6KTfPtnqau++-g9CXD0LOpPjp4L+b9cu8mMSQ@mail.gmail.com>
In-Reply-To: <CAO8sHcn=b94SL6KTfPtnqau++-g9CXD0LOpPjp4L+b9cu8mMSQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 23 Jul 2026 15:36:28 +0200
X-Gm-Features: AUfX_mz_oyfTmFTsWe4DqyoTwZaT4FqILYbq_ROAU2MaHiET5jL3AiHVyZbENNo
Message-ID: <CAOQ4uxjk_Se3dq3exxd5WS98g287HUMjVAucipxBX=T0W-8d6A@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] Proposal for Cross-fs copy_file_range()
To: Daan De Meyer <daan.j.demeyer@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 3:05=E2=80=AFPM Daan De Meyer <daan.j.demeyer@gmail=
.com> wrote:
>
> Hi Amir,
>
> I tested the series on top of f6cde11eb46e and cherry-picked these
> selftests:
>
> https://github.com/daandemeyer/vfs/commit/0b0e47d408311fe2b4a3e1711656f83=
6b56e10f4
>
> All four tests failed.
>
> The accounting test reports two reads and writes, and 128 KiB
> accounted in each direction, for one 64 KiB copy. The outer and
> recursive backing-file VFS calls both account the operation.
>
> The credential test fails with EPERM. The explicit source check uses
> the source mount credentials, but the recursive VFS call checks the
> real source again while the destination mount credentials are active.
>
> The permission-order test times out because the real source
> FAN_ACCESS_PERM event happens after the destination inode has been
> locked. The process handling the event cannot update the destination
> while the copy is waiting for its response.
>
> Finally, denying that permission event still clears the destination's
> setuid and setgid bits. ovl_copyfile() removes them before checking
> permission on the real source.
>
> It looks like the root cause is that OverlayFS-to-OverlayFS is
> classified as FS_COPY_SAME_FS before the FOP_CROSS_FS_COPY checks.
> That leaves it on the existing recursive VFS path, so these issues
> remain even with the series applied.

I am baffled by this statement.

As far as I can see, OverlayFS-to-OverlayFS, which is classified
as FS_COPY_SAME_FS should not have changed behavior at all.
That was my intention at least, maybe I have a bug (?).

If I am right and behavior did not change then what are you saying?
That OverlayFS-to-OverlayFS copy_file_range() in upstream has issues?
Are those issues unique to copy_file_range() or also exist for clone
and splice and regular read/write?

Note the overlayfs model - do every operation on both overlayfs mount
(with user creds) and on backing mount (with ovl mounter creds).
Taking this model into consideration, what in your opinion is broken w.r.t
upstream [1] behavior of OverlayFS-to-OverlayFS copy?

Thanks,
Amir.

[1] upstream + this fix
https://lore.kernel.org/linux-unionfs/20260712122421.203113-1-amir73il@gmai=
l.com/
