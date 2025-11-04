Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206F338FA3
	for <linux-unionfs@vger.kernel.org>; Tue,  4 Nov 2025 09:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762249550; cv=none; b=pzrHMSw/4qtQ8MudUQQStCylXwb+7lw+TlOrHEFPrhCXV6Wrv+8INKcL/m2/EfpEmV4lHinCIrgIljPLIKluQp6X6Z3u8foCMZijF1AnZd3FsnBstJSzKcIYWMV7Jo4Ns/WNJf/oMdrdOYPQLf76YDukP/p6mWuSG1Swkg1AaR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762249550; c=relaxed/simple;
	bh=Y/8kkJtUlvT/f8ywlYeX1B4ZoD/ySaLtnH0dGnqnmAA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PZh9F6F7V4iDtoAcTmjbIJySQH6JxZFXWIV0a0fYRvVepnKCa8/JEza30RbEq4zj0OLsXRnMFof/3uKa4gyp0hV5xFi7p3K1CjpVjmE6V/6F35TxLo+hPPPx8ojkMuNcqXial39kBEjGZyD9npYl+SasEiHJfC5jQQdTyLslkFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rf3pNu0C; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rf3pNu0C"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-64080ccf749so6854864a12.2
        for <linux-unionfs@vger.kernel.org>; Tue, 04 Nov 2025 01:45:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762249547; x=1762854347; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xKJdWvkPbuojvyFkWrgOJDggLZVTca+r/oAisy+M4uA=;
        b=Rf3pNu0Cg1d48tOeaZtZaLUkE/PEszLIZCf1p0J0eQREPNueGK+mEQ6TOQwKX0fevP
         DG7Bf49VqBKXjMXfX+cxHFvoOdj0HEyx787WuG/kGgy0ZKASykSskdCNsJbQakDLDfmB
         t87jC0FfJaGK2EkHbJ2skXAhafGEtVnaWmFwNihX/9k+M/WkZkLc1S7n6MArxGDLViHA
         mxPiF89Dk7LQiqHnGfCi3TdkBqKIDuUcIWubluYRrUL9svX3Pgcse/je3swjxwnN1W1E
         gUlOLs/2RRZquqbAd/Rto2820kkWJatdFt7IFS0sjW6lP07/tMpw3G0PdkY6g5ulk8uB
         zzkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762249547; x=1762854347;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xKJdWvkPbuojvyFkWrgOJDggLZVTca+r/oAisy+M4uA=;
        b=KE2lYlKs0et9Pw5tDvQE8pN+L4cTl5dakV10B1PlV7KRFhqBkeekxgwNTfIIf3PkeO
         gQD7JTBbkP9cEEJCs8T2klB1GEjhiNHr/gW8PMHipeZPMENpJ+Oj+UQkfjWTd0cA1vSq
         jy2pbXGiJE8IYxqxixNx7uN9oULwRvc/chO4JsSKgyM1gx9BYwTURV2YbBIjrmCxt8Ob
         sAzNigrr0jtscwLZQF+0P69QT77R7QxWWM4S/fKl4YiMLl8H72YEvq5i/YAaF3mgYst7
         xk1O/SKyT620kFsuEJ69wsJfdvX6q4Zh6YRYKnwT91WgFKmCP+u1G0W28zauXGxR9tUr
         9Z6Q==
X-Forwarded-Encrypted: i=1; AJvYcCW3QGUQ+BwIjo+jHOH46oX9D29PWBzdZ6JiAn1UrwNZomHX7bU9SfJbE6BW/eoLnDGGMGbg87+5z+NLOpOH@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8ZOimITOgVZuGl+N52AE7hraV82joRbne2HAXe4HbNms7VvWO
	+Rc4LhcxPsFaejPSe2beJV8Eneojn33saDdt8tRPNhOSnXH4PLreQPqPrvVNAsY0APnWV3tmXzu
	ElN+Iy5c9n4P/gvYKRonGjwknMamtLkw=
X-Gm-Gg: ASbGncvMYV49gw4FdDZcSAoUW49tiRY20goKZx9c7x92hwTkbCJKc0C3oMys0y0zRW8
	1Q1AMYPGUBIKoV9NRCDpvNPLbueBuDSDl2SLhvtrQj6upsujAqYtjyVtotQaut1l9T3YXB344hh
	/rgYKBNDwGHr5w6RUsv6TZFIAi0/+oZi+lH0ICo8sbDyEWQV0tRFcG8ltsiHLBJSla+9jm5AWEL
	HL+awlJVX+MG3wCNPp2KFOYcBP7GfdL5QFNVJFBws8ixArJCxRegcrOpO0IygtaWD4r4dkR6EKK
	n9MTUYtsCxamD1qdR68=
X-Google-Smtp-Source: AGHT+IHXA2qJBi6f10DqUtNaDt/G9hT+Ey8B/WnoFdz3Hmrh6KCUpLdIDtROPfgXbvSfxz+h0BRwI+TkCKOqKrtbbyk=
X-Received: by 2002:a05:6402:1462:b0:640:ea21:8bfd with SMTP id
 4fb4d7f45d1cf-640ea219598mr1427481a12.31.1762249547237; Tue, 04 Nov 2025
 01:45:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251103-work-creds-guards-simple-v1-0-a3e156839e7f@kernel.org>
 <20251103-work-creds-guards-simple-v1-14-a3e156839e7f@kernel.org> <CAHk-=wiSmez2LFEpM05VUX=_GKJC8Ag68TJDByVPO=x4QwjyuA@mail.gmail.com>
In-Reply-To: <CAHk-=wiSmez2LFEpM05VUX=_GKJC8Ag68TJDByVPO=x4QwjyuA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 4 Nov 2025 10:45:36 +0100
X-Gm-Features: AWmQ_bn9rw0ha0qFFSykU1xP6jfkkEMSMAVkMSHJG30ZX97XNHwd3yxbJVnihQI
Message-ID: <CAOQ4uxhw2Tc4YXwhkS=5EVC3Tg4F+QyrA7LE3V29pNhQ4WJeyA@mail.gmail.com>
Subject: Re: [PATCH 14/16] act: use credential guards in acct_write_process()
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-aio@kvack.org, 
	linux-unionfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, cgroups@vger.kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 4, 2025 at 12:04=E2=80=AFAM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Mon, 3 Nov 2025 at 20:27, Christian Brauner <brauner@kernel.org> wrote=
:
> >
> >         /* Perform file operations on behalf of whoever enabled account=
ing */
> > -       cred =3D override_creds(file->f_cred);
> > -
> > +       with_creds(file->f_cred);
>
> I'd almost prefer if we *only* did "scoped_with_creds()" and didn't
> have this version at all.
>
> Most of the cases want that anyway, and the couple of plain
> "with_creds()" cases look like they would only be cleaned up by making
> the cred scoping more explicit.
>
> What do you think?

I had a similar reaction but for another reason.

The 'with' lingo reminds me of python with statement (e.g.
with open_file('example.txt', 'w') as file:), which implies a scope.
So in my head I am reading "with_creds" as with_creds_do.

Add to that the dubious practice (IMO) of scoped statements
without an explicit {} scope and this can become a source of
human brainos, but maybe the only problematic brain is mine..

Thanks,
Amir.
