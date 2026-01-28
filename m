Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7C52DF12F
	for <linux-unionfs@vger.kernel.org>; Wed, 28 Jan 2026 10:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769595606; cv=pass; b=TW6sGEBnzpt7/UDZx7wXnPMi6XNv/ecn4X9Vbq6gNzxVVSOW3+SQEIMzqp9OWq7uhaNIIsWgSUv1kdAgwfBKDYWbT60nlqr19hy43Ys9O7Rp4mamST+cnvJjZCGN2zg8qUPmf2JlAiLabyDTUUWrvuurUIZPJMLoz0+VxhkfXlc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769595606; c=relaxed/simple;
	bh=YxEx3+qyM0vv/qA2ICDmmm3V7t1+L97nkIncqHExyNU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=idMAgqkKKWRgGU449K7VvVO6wFlRMHiQ55lwMxCRD0/1pAbfaVBQX6JcFJ8XqiMJxzef8cjHiPK+SC1l4sTMk7cZS3XhpzaWRKHHtJDEcutHACtXfIz6dmy6awtEBVPR+Vk7a8ngkc5pEpDApa7uX2YdvQzPWAdsXc2glkCPYBo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=buSCVAdQ; arc=pass smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="buSCVAdQ"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6505d3adc3aso8894776a12.1
        for <linux-unionfs@vger.kernel.org>; Wed, 28 Jan 2026 02:20:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769595603; cv=none;
        d=google.com; s=arc-20240605;
        b=glb6S3Gb0dhLOC8YoCxSVqSKMocX7xDg3xR2CqHZPlXNV0muYA14RDg5hV+KriNZbg
         oyhjED6qLLMvNMUY9pLq1LVWVVToA29Hw9abH2WSzwmCTT6CoOwZKiLCDe5wAnYPna2T
         /w7UndtXLwfVSl+hVXyS0KfI0PLWDdOj79su1z+g6xsguBJtYcH2oPHmI05T04VYypfA
         8FlzXVdYe2JU7n4/IE2a29/LSlqpUPAwKZi7xREmJ9hLwO8rhaaRcCC83ju4+eo6UHP6
         B5z15FMKBQbSt51B0OHIIErOLYTsuD1V8iozuePm9NVuBIP5CqNF/tFyv0itjkdo4Ukv
         PThw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5SmFQoj44C7kNaIvhbYLuwTilxhkeoOofm55ab1N5NQ=;
        fh=pcke9njmG4CHeWGKVVOq+Pi4QzX+/M3TYDBjMBkOtnA=;
        b=a4irt6WdadLE6BRsbODALEv3fQT5a1j9FZVxYwNa+P6y0d5QOoIh+v8JlG2/P4bNEj
         /SbbelE0iZzCgRwDDsIBBncmxwGuVrMv1bFuu8hO66DkP65/tgV8KGvgy1AVaEeZ0TLW
         rWiOkZMUN3TLxIK0JwGgjOpsh8AkSIS3Lqk5W5B3rQR/qIZyFpIuC3x8qJY/RW9x4DrG
         Gr9+cJdGG2nyaxbOGdklNc916xIILT/AHEdUdr8Nzfd1A8wGTkz6nhYcplHiO7tm5aPs
         3le3irPfeu8HVqSCb1thQcR6M5cbLI8/o7H1wivn06EXDdl8MNzF45ZbhWwOI+X8jmXZ
         2c5g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769595603; x=1770200403; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5SmFQoj44C7kNaIvhbYLuwTilxhkeoOofm55ab1N5NQ=;
        b=buSCVAdQjExCnVCgKqYTnnkNjXY9hZuTDj9VqjHdzoQhkRm1DGRq/RsJlB8VVtSY3K
         hfw05gRWLSuxSfRz78WbbohFGrCNqNFCIpET17rIDe270z4OxyywKaewWBU9gnGF69U3
         2yeiG+ZolF6RaHERCR8zPc1GN04w/11Iv9khoX2sHyudSIgUH1Ux9nLY5r4my7XLxnX4
         VjkW+/04UTP5q32JN81EcRecr3eLiGh6kcfcAKecG8XnEhlXotKpZMAkMlA3ejRpJFWL
         UwTdxedJFFg5h4ujuI8CzcX65krdSVdsPo9USVC6BPo5VpGwGr89bP0BCSD9bNy50Bo8
         8wpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769595603; x=1770200403;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5SmFQoj44C7kNaIvhbYLuwTilxhkeoOofm55ab1N5NQ=;
        b=ACUNLkiozmg1LHRNP9DHVq2GZUgehleA+/LEIOXGD4g7N3VakkgzntykuaFqo49tR5
         ipHKi8J0DJlejbdOrKeodUFxkLXpiBx7kxBrp2br1PCSBDYqX8G80k0L/V1jUSmNEJgw
         Y2Bfx/vtpYtmIhIDpVuGy3C8wXQ7OBPRELwmWEcvGYhR6Bku9KKcK3O+UVfsdgFgQCHo
         cxVXi6z9XC9T3TX8N0lrNq2ghe8fvejJVxH9FyC0b+7AV8rqHPDxqz5XMm9Ql9jcnzkD
         9/9Ovj2QoxziJ71NRz7TJPQPSLSn1TvhgIMcKcT9peOq3ymErAN1hAQ/d6tOsHcBaqUe
         8YxA==
X-Forwarded-Encrypted: i=1; AJvYcCXUhrrwmtAjOCRWuYACOT/Cl2sz3BlgFc0H/Pk0MD8UAzZVuayKwsy5eg+n6bhNHCHRNNZL6yppaxU4B9Qr@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9X6PuUgffxwIXQ5doUJzIQz+2aM7xcXPne/5PQ7TqeuKRJre+
	Z2UmlfztRUdzbEH4nyr13Ofab3Smco/s8ggIdAWPkNZAUYyrz7CUieq7E57zDqMRIwJ6a+sDSmc
	F63Gw3uwPc+huDqSkNa84EdwPQXYPaJjpnpqV/Qc=
X-Gm-Gg: AZuq6aJ1iLa8VuFyDzaHSojUuej0R8i+KfIsi7A/G2ym5XzeSyUlWBScQ+t344pC1AV
	aGqmL/heCj+vWNiZh88no2Q0XmnWPDNM/a0NeslDHMvf4LK2RcLDTvgmX7iiRCByKzmkBQ7Dt7W
	dJUhu/QcVkx+6GF36DN1NghO8UNwq+h99hfsa+QGUiYKp8qULxWk3jNDvc/5YeS2qfbQkav7cHH
	8lqdsjsBSFsYoVMyU2JRtoX9JfCaHfr37lMR00x1dE06mIvtI1ICzq7ZMLhwldkslY86gpmsVXQ
	P37iQ557LSW3VDIRpQu7JVVFlbYlKg3/4MberG1d
X-Received: by 2002:a05:6402:40d2:b0:658:eca:1fa5 with SMTP id
 4fb4d7f45d1cf-658a608d124mr2926296a12.20.1769595603335; Wed, 28 Jan 2026
 02:20:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJfpegt9yLioW1dEmGYOfib=TcuWVom=Z+a+bN+jS_8wFie90Q@mail.gmail.com>
 <20260128024212.1818250-1-wangqing7171@gmail.com>
In-Reply-To: <20260128024212.1818250-1-wangqing7171@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 28 Jan 2026 11:19:51 +0100
X-Gm-Features: AZwV_QhLku11maqdRojAuyroB8yR4FpZg47rN_BM_9_YxbFv9H7JSgwvM3bNqtc
Message-ID: <CAOQ4uxhvnqg-_rB+1ch_nvZmP_s9a3RGxpaLP-9=UKTc9PWy7Q@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: Fix uninit-value in ovl_fill_real
To: Qing Wang <wangqing7171@gmail.com>
Cc: miklos@szeredi.hu, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, 
	syzbot+d130f98b2c265fae5297@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 28, 2026 at 3:42=E2=80=AFAM Qing Wang <wangqing7171@gmail.com> =
wrote:
>
> On Tue, 27 Jan 2026 at 19:19, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> > index 160960bb0ad0..9ea3cd11dd93 100644
> > --- a/fs/overlayfs/readdir.c
> > +++ b/fs/overlayfs/readdir.c
> > @@ -755,7 +755,7 @@ static bool ovl_fill_real(struct dir_context *ctx, =
const char *name,
> >         struct dir_context *orig_ctx =3D rdt->orig_ctx;
> >         bool res;
> >
> > -       if (rdt->parent_ino && strcmp(name, "..") =3D=3D 0) {
> > +       if (rdt->parent_ino && namelen =3D=3D 2 && !strncmp(name, "..",=
 namelen)) {
> >
> > Yeah, and also the str... functions only make sense on null terminated
> > strings, so that needs to be memcmp.
>
> Thanks for your idea, but I think strncmp is same as memncmp in this case=
.
> strncmp dons't use null terminated.
>
> ```
> int strncmp(const char *cs, const char *ct, size_t count)
> {
>         unsigned char c1, c2;
>
>         while (count) {
>                 c1 =3D *cs++;
>                 c2 =3D *ct++;
>                 if (c1 !=3D c2)
>                         return c1 < c2 ? -1 : 1;
>                 if (!c1)
>                         break;
>                 count--;
>         }
>         return 0;
> }
> ```
>
> What do you think?

I think this discussion is not worth spending our time.

After namelen =3D=3D 2, it really does not matter if we use strncmp or memc=
mp
IMO. I will post a followup patch to add name_is_dotdot() helper and use
those helpers in overlayfs readdir code instead of all the many open coded
variants that it has now, which may be safe, but still ugly.

In the meanwhile I'd rather apply v2 as is so it could be picked by stable.

Thanks,
Amir.
