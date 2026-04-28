Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAB67404E
	for <linux-unionfs@vger.kernel.org>; Tue, 28 Apr 2026 16:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777393966; cv=none; b=ioWwBPd/LtEf/bxCo49yFrTaztdpyP55addYoZjjiuugVIMV7+xg+gfxKXo5D5ZmPkU1/ro8ib7wZMwvClTcN//3EmpGb/fCQ6Pd8LXhpKeu2NivP9dydf0t34cn/UQ2AfB8T8YaRirAlBHwIJN9b/SWeSAMcGt8p0vf7/Gm+34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777393966; c=relaxed/simple;
	bh=UXi3to+PEeM0vXAZmtoShs0caavlFjs/qq6Gqzz+kdA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z2uGbidIqlx3UZ+4ER0UWH++h3iBeds9ufQoyDVM/Oe7LA4VCz403dcLdOxBQttK6bR9uyFgfRzbBA9kVRZIPB+aE/V2KWVTc4xsLNxdd/HEgS9+jTUN+0GbExwvJwIED1krWWzKlG+6RLtZBWGxcGCEbSMhyYpx9zkoqTZuglQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=djVqNUdV; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="djVqNUdV"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ba545100a13so1360744366b.2
        for <linux-unionfs@vger.kernel.org>; Tue, 28 Apr 2026 09:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1777393963; x=1777998763; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zdQshYQj3noQptsym9r2OjNoPP3O2vv/eFEz4ctitBQ=;
        b=djVqNUdVNkaaQmzdPvG00A/7PuqmLMfJrUFwDGo0g0JSyLbIXE320S0Q92Q3/ftBA6
         oG331K1HZUhl8NGDzh8EZGWfI7PqKHwEVaB41XFFrIZQNZf1zd/zwGGRTh7Z7lwvyEo/
         R05Xk/TcC9hnU/KbgfGOgFBBJTZC5YOw+bc/M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777393963; x=1777998763;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zdQshYQj3noQptsym9r2OjNoPP3O2vv/eFEz4ctitBQ=;
        b=puPhF2d2NYnIblTuXNAhR3krDKQkYtuaWRXm0+SL/b5bkOZopn8A0HUpjYt4PQc+68
         OlSRXYeJhcFjmLU9sQCH1iMqaH79e+KvdOMFGaD/NMdHkRDFjWJIG09/94KYnGRlQgRx
         0jQ2j7dYLXzcfzgC13dT9quI5Z9TaDEnjal8692KlsscqLF8WN9fYpAl4fsJPmEp5cOq
         MRZ8h1SKxODco7G55ucHTR5ZrLXdky2J904j/ys04s+3hykfAAU+cW78ezgRbvk63Qjf
         j3ebbdW4i02jUA9X6Yu32OBNziUE8gZ6VFZftusg4rhGqqTjCwEzI7UXwrR/87cRHcJ6
         m9hA==
X-Forwarded-Encrypted: i=1; AFNElJ/cUCWxXhUUOiOhJdrp9ncVtHxf57IXbNjkqbcluMiMxiRaFT+b6znYVv4p0QxlNfOx/dUvAcxLxQZAP3V3@vger.kernel.org
X-Gm-Message-State: AOJu0YzDRd8wdM92Qts/QjNIhWtZe0F6uYUu1omTK2iKL9ld9KcgGoym
	k7jZXjM7lfw+ynwAMJV5VlBUFv8NOp5yS5ydmEOVB+QO934ATZ+zqRuO7TKSOnm9WOx6JBv4iYK
	fRasjjsCrgQ==
X-Gm-Gg: AeBDievPBxqsLUFKU0qEc3vkW1HJxBaKV3Ql0B3THYJXdtyH2325FBD5kPNRgzCuMl8
	ky03ofPjW6NwE7ChYSKBaGbYojIbAqFbyp9P8r8xEa58e4m0V45U2mGG08H77TC+xh+R8GUHGoM
	rRpiEdMPR2MKmzwP7ystwz5Gv/AZlnkaDFSunz7X/O7Q8CXI+Dyq88JugfB2w+N2xWOqPdjpndu
	vA+KbEfgSuyVD0dpJXGwwkUi3+i4Qn6vouNxn4SZr48UZZukvHZBdBMkuUm0PQDJxhIdogPFrAk
	9HiLyR/L0YbkS4+ToCMlENNuNkcLtKMlluSnCJv30RRj4gwnM7HfJyE7jeeQe4vrzWXxMVZrzRa
	VdxEuUTuMDWWgk5Lew6bnt4kN7RC1n833G9SvNINwueU3lEpEJ/sc9Fnk2ptXYICO8k8I53RLgf
	hKk6RF5JcQHEhB3uPXzY7hzAqmYz/Pw0TxdFaHQN3nRJUEiRoaVYKyinSwMIIyewxa8timfw5Pj
	WBqADr0QIc=
X-Received: by 2002:a17:906:c38c:b0:b9c:aae6:907e with SMTP id a640c23a62f3a-bb801ad8a2emr176344866b.13.1777393963446;
        Tue, 28 Apr 2026 09:32:43 -0700 (PDT)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bb80b2adeaesm125223466b.32.2026.04.28.09.32.41
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2026 09:32:42 -0700 (PDT)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-67893fba9c3so11046703a12.2
        for <linux-unionfs@vger.kernel.org>; Tue, 28 Apr 2026 09:32:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8+c9QmHLxkEFoqHJL2rRoOfQcCKvgpIEaeRTMeQIADzFtw5H4pw4kEs6JGuU+uzE7RzZ4KUZfwgC07sHvN@vger.kernel.org
X-Received: by 2002:a05:6402:4498:b0:670:e9ce:203c with SMTP id
 4fb4d7f45d1cf-679bb05d621mr1866002a12.10.1777393961533; Tue, 28 Apr 2026
 09:32:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260427040517.828226-1-neilb@ownmail.net> <20260427040517.828226-5-neilb@ownmail.net>
 <20260428033738.GV3518998@ZenIV>
In-Reply-To: <20260428033738.GV3518998@ZenIV>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 28 Apr 2026 09:32:25 -0700
X-Gmail-Original-Message-ID: <CAHk-=whXZz=-XnJdMGzM8BCwDkoqU0yDNKWyrpZSwXzchxsPUQ@mail.gmail.com>
X-Gm-Features: AVHnY4IIvtSv2v5AokZFbGGGL2ooIu4U0QBZlzJ1iurrKn3dZQo8WV0HU53s1sE
Message-ID: <CAHk-=whXZz=-XnJdMGzM8BCwDkoqU0yDNKWyrpZSwXzchxsPUQ@mail.gmail.com>
Subject: Re: [PATCH v3 04/19] VFS: use wait_var_event for waiting in d_alloc_parallel()
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: NeilBrown <neil@brown.name>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jeff Layton <jlayton@kernel.org>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
	Jeremy Kerr <jk@ozlabs.org>, Ard Biesheuvel <ardb@kernel.org>, linux-efi@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 27 Apr 2026 at 20:37, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> I definitely like the calling conventions change, so much that I'd be glad
> to pick that one right now.

Honestly, while a 19-patch series isn't big as these things normally
go, when it comes to something as core and subtle as the dcache and
filesystem integration, I'd personally be very happy to see this
merged in small clear pieces, so I'll happily take any parts that are
good on their own early and separately.

So yes, please take any cleanups in this series asap, rather than
necessarily keeping this as a longer pending series.

               Linus
