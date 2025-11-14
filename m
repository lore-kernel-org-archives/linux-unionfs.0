Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D7F341648
	for <linux-unionfs@vger.kernel.org>; Fri, 14 Nov 2025 17:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763142134; cv=none; b=cRLX2uFyWW4jctIDStGNdKrKxBTXwyo8jkKuUmC8F1V6TwS2E4Sd4MtmdHyYVs376YW/lK6BTBnzpfnmcMEoxUsGwUlUweRjUM3B9ivEyDg9C47ZVrGI1tBBRTG7DA1I4/GN7PIVxS6vJMIWe3138G/Jm8+vDX9gQMlC1zzHxgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763142134; c=relaxed/simple;
	bh=Ck3PsG2YZBT3+DkuH0L2cNVUndhWauf+ZUbtOHHIsMc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mceNwtoMl0ORi7iqXA5VQZoEh6OjDaiRUdXr8AAuanoA0RumSQH3wc3ZV+sj4EPrxY63WWjO22OfzhKTDMU7smc1JXR18h+2c1HPlqCqFrufmGcIraLyzQ+kydHjHz9ckQYpJVmLtRhNFp6r0ktBY5BMmcofZOr02OPzopQGh8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=Lmsn/JP9; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="Lmsn/JP9"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4ed946ed3cdso16540661cf.3
        for <linux-unionfs@vger.kernel.org>; Fri, 14 Nov 2025 09:42:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1763142130; x=1763746930; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FpAxRfX7+XU3sg7WElj4wsWAhBbaiRWwTC7gp0ZtA/k=;
        b=Lmsn/JP9Hn8sSuHtk7YBivjPsa+jAtCjCwNsVrhJtGeuX4e2iIrnVG6vcVIk3BwrUn
         JuGLWgaO4CH7RuxHOOa7DEIv2JyvnoU/HoQVg8Uyi1MfuglFbcRbwI1m/19nBrdUSNZf
         m3aMfYO5SOOEg2N//6uREMOjXfOExVzHEmNa8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763142130; x=1763746930;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FpAxRfX7+XU3sg7WElj4wsWAhBbaiRWwTC7gp0ZtA/k=;
        b=S4fgdxmlJryoSWR+lBfuecXpImofUg96F/iyAt1RXGopflYB8uuY8bRjXjHdOmufed
         BK5oUjJ7V566u7ajbam8uVd2cW1lFkHi2EsHZ/p+vy5bgTwa0Xbdgb5PLkvnTWf8P8rn
         Pw57LG8RjbJBQ9R9xRg2E4pWbHq7souUgJbzpxikViF/OElqK8D9gzRAcq5n/dRjYyFY
         YrarSsrvSZICRq5JL2MzsrfV7wLud3k/zfQW+ewun5SKu8aAzMoYq2NS+11J68QzODcl
         jepO71hEHAm/xt0mueDYjzMxvRGc9vd/5V7MCmVMwjPVUvcFa+Nk9MXERq/v4Uxc2vUt
         CJww==
X-Forwarded-Encrypted: i=1; AJvYcCVmEmsWc8md+Me9QDUc2KWJJICUlvuJPt7sOX4sLczEdNAE9iOGqqyRJpwHNuwU9EzqZkqtmwF/zJ4LcGEu@vger.kernel.org
X-Gm-Message-State: AOJu0YytYoI/edMPZxMshNXMZrIN4h9vEGavwAJS8intsQHoc93K1eiw
	73bVL2O8LWgVdgfyvhHWL4hUHBivGHCvnwo2Bs1Bq0bluruonFOGCfXyq5hb9U7I3UNryjM8WCr
	CAILX2Y9LKiUFnrDZcwsz+jRuxhhg6XWclGPnQG7YgA==
X-Gm-Gg: ASbGncsxq14LAxayKVKsL4nqysAlfoJvcCC9k0EhedqkM5z+/hreh73ax/DLKVYCfTf
	GzgI+vGa+IunFu5ypoeKdKrrhe91T3jVvGG5z2WyuxWcJeu8rek3LPNozterY8kKfqT9u8Kz4Hq
	bOt+QmhTrCu73cjr6rK41WXp5haluAz2aMDnP4KlJNGKjgZQuOJFBwcRulvVDLJB8uDKOrukrJL
	fuvDrxXsKVhOTKCDPCzC2/lF5tkz1iWTHmX74TeC/iSiuDhk06uZWiHnEZZLkTD3XQ/LtWSJUZt
	MrV0MKQPwbJ6Wulp9aLnNNTKI2Tk
X-Google-Smtp-Source: AGHT+IG8oRNEQTwOYfdLAuDndZk1qi6Lyv5tVmzFUUqZK8ufbDw/Uf511bZlhVgLaFRWtMGjOknMUzz+F6oiwCmXBO8=
X-Received: by 2002:a05:622a:1a1e:b0:4e8:aee7:c55a with SMTP id
 d75a77b69052e-4edf20a221bmr57184441cf.26.1763142130553; Fri, 14 Nov 2025
 09:42:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251114-work-ovl-cred-guard-prepare-v1-0-4fc1208afa3d@kernel.org>
 <20251114-work-ovl-cred-guard-prepare-v1-3-4fc1208afa3d@kernel.org>
 <CAOQ4uxhB2am_xAGugZvAiuEx7ud+8QGPJBwcA+M+LmRvWC-nsA@mail.gmail.com>
 <20251114-gasleitung-muffel-2a5478a34a6b@brauner> <CAOQ4uxie_CSG7kPBCZaKEfiQmLH7EAcMqrHXvy78ciLqX4QuKA@mail.gmail.com>
In-Reply-To: <CAOQ4uxie_CSG7kPBCZaKEfiQmLH7EAcMqrHXvy78ciLqX4QuKA@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 14 Nov 2025 18:41:59 +0100
X-Gm-Features: AWmQ_bkMQWRwIOVYfcltNX1QVP7XG0IYaUQqBxN3AT2GDcB7daO0WvsP5XHhKPw
Message-ID: <CAJfpegtZhfU7hmYcom9LgnkhXbZ8peLtRm1CDhVy2JXfqJUGkA@mail.gmail.com>
Subject: Re: [PATCH 3/6] ovl: reflow ovl_create_or_link()
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 14 Nov 2025 at 13:07, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Fri, Nov 14, 2025 at 1:00=E2=80=AFPM Christian Brauner <brauner@kernel=
.org> wrote:
> >
> > On Fri, Nov 14, 2025 at 12:52:58PM +0100, Amir Goldstein wrote:
> > > On Fri, Nov 14, 2025 at 11:15=E2=80=AFAM Christian Brauner <brauner@k=
ernel.org> wrote:

> > > > +
> > > > +               if (attr->hardlink)
> > > > +                       return do_ovl_create_or_link(dentry, inode,=
 attr);
> > > > +
> > >
> > > ^^^ This looks like an optimization (don't setup cred for hardlink).
> > > Is it really an important optimization that is worth complicating the=
 code flow?
> >
> > It elides a bunch of allocations and an rcu cycle from put_cred().
> > So yes, I think it's worth it.
>
> I have no doubt that ovl_setup_cred_for_create() has a price.
> The question is whether hardlinking over ovl is an interesting use case
> to optimize for.
>
> Miklos? WDYT?

Hard link is special cased in several places because it's only
creating the directory entry, but no the inode.  As I see it it's not
about optimization, more about hardlink simply being special.

Thanks,
Miklos
