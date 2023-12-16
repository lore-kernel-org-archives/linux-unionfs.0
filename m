Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8289831A63
	for <linux-unionfs@vger.kernel.org>; Sat, 16 Dec 2023 18:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EPtgRFMu"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2cc61d4e5aeso4396841fa.0
        for <linux-unionfs@vger.kernel.org>; Sat, 16 Dec 2023 10:26:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1702751184; x=1703355984; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Imi0HlHoaDO7uNQ9xiA54WrsCxlCdM8Cvn4XhN3R5LI=;
        b=EPtgRFMuPe+3ZoSvGnNIVtwyJuBWte7e5kLOR1sRXdKALOM6P1zUcEuRPxGkBhnNV+
         cLGx+fCuvtXizGtBp1pnr+yiwUBkjaeNxcq40/W8aFi4pq9Tf1rNAbUzvYTAtiLumLGX
         La+EMwAC0nVLbNXeSJPvo56kVXsPTQ/FWkIoc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702751184; x=1703355984;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Imi0HlHoaDO7uNQ9xiA54WrsCxlCdM8Cvn4XhN3R5LI=;
        b=i21EbqJ9LwzcLMTot9erGj7cfnBvUglxJDmeZ4+WvDdt6tVYD3Fj5ZmBsuJ+j1b8rj
         dB+Yn7+ZAceI3xvntUqRWL5dntanxkimywwRZqDQjwV8zRJ3E12tLX93parBzMfMR5VJ
         civZd/FXNJXd2oe4gM09c+MXaaUPrGBccyDiOiMGrl7Yux0pASkF+ZHCAEWzkY/ELVHf
         PDvZ+SjwKxudtUvFDFagrbGSRzjNQX97nj9rzmv93qIEWytY/aHK4/32Qp6p5v8+/aKx
         fktJHpW6/JUKRRZxgcWCNQox6vVp99YcQ4wikC8NemC9XUShdWknw/RoCtzGD3Lc/VBr
         ipVg==
X-Gm-Message-State: AOJu0Yx/dgmy7MtsR0LxkcovMukN2s9hGKGahciZ8dpeOZqrIrQkoYQj
	qQXEmpQ6LxVkRkmvlK3J1OjYVtChWaRhIdJMoMpPoJJF
X-Google-Smtp-Source: AGHT+IHkslf8UyaJYmolpsBqUU4kfoHkeJX/S3nIuUMuILuGzGkT4odqOjw4j9rKUzeJxpxCLIhefw==
X-Received: by 2002:a2e:a22c:0:b0:2cc:1c3d:35a9 with SMTP id i12-20020a2ea22c000000b002cc1c3d35a9mr5096428ljm.42.1702751184468;
        Sat, 16 Dec 2023 10:26:24 -0800 (PST)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id f18-20020a05651c161200b002cc46e039c7sm729305ljq.108.2023.12.16.10.26.22
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Dec 2023 10:26:23 -0800 (PST)
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-50bdec453c8so1937659e87.3
        for <linux-unionfs@vger.kernel.org>; Sat, 16 Dec 2023 10:26:22 -0800 (PST)
X-Received: by 2002:ac2:414c:0:b0:50e:3183:51a3 with SMTP id
 c12-20020ac2414c000000b0050e318351a3mr113023lfi.129.1702751182566; Sat, 16
 Dec 2023 10:26:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOQ4uxg-WvdcuCrQg7zp03ocNZoT-G2bpi=Y6nVxMTodyFAUbg@mail.gmail.com>
 <20231214220222.348101-1-vinicius.gomes@intel.com> <CAOQ4uxhJmjeSSM5iQyDadbj5UNjPqvh1QPLpSOVEYFbNbsjDQQ@mail.gmail.com>
 <87v88zp76v.fsf@intel.com> <CAOQ4uxiCVv7zbfn2BPrR9kh=DvGxQtXUmRvy2pDJ=G7rxjBrgg@mail.gmail.com>
In-Reply-To: <CAOQ4uxiCVv7zbfn2BPrR9kh=DvGxQtXUmRvy2pDJ=G7rxjBrgg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 16 Dec 2023 10:26:04 -0800
X-Gmail-Original-Message-ID: <CAHk-=whzaCCucr9odvFWcWr72nraRgejD90Nwb2tP8SBE2LTQw@mail.gmail.com>
Message-ID: <CAHk-=whzaCCucr9odvFWcWr72nraRgejD90Nwb2tP8SBE2LTQw@mail.gmail.com>
Subject: Re: [RFC] HACK: overlayfs: Optimize overlay/restore creds
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>, hu1.chen@intel.com, miklos@szeredi.hu, 
	malini.bhandaru@intel.com, tim.c.chen@intel.com, mikko.ylinen@intel.com, 
	lizhen.you@intel.com, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Christian Brauner <brauner@kernel.org>, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, 16 Dec 2023 at 02:16, Amir Goldstein <amir73il@gmail.com> wrote:
>
> As a matter of fact, maybe it makes sense to embed a non-refcounted
> copy in the struct used for the guard:

No, please don't. A couple of reasons:

 - that 'struct cred' is not an insignificant size, so stack usage is noticeable

 - we really should strive to avoid passing pointers to random stack
elements around

Don't get me wrong - we pass structures around on the stack all the
time, but it _has_ been a problem with stack usage. Those things tend
to grow..

So in general, the primary use of "pointers to stack objects" is for
when it's either trivially tiny, or when it's a struct that is
explicitly designed for that purpose as a kind of an "extended set of
arguments" (think things like the "tlb_state" for the TLB flushing, or
the various iterator structures we use etc).

When we have a real mainline kernel struct like 'struct cred' that
commonly gets passed around as a pointer argument that *isn't* on the
stack, I get nervous when people then pass it around on the stack too.
It's just too easy to mistakenly pass it off with the wrong lifetime,
and stack corruption is *so* nasty to debug that it's just horrendous.

Yes, lifetime problems are nasty to debug even when it's not some
mis-use of a stack object, but at least for slab allocations etc we
have various generic debug tools that help find them.

For the "you accessed things under the stack, possibly from the wrong
thread", I don't think any of our normal debug coverage will help at
all.

So yes, stack allocations are efficient and fast, and we do use them,
but please don't use them for something like 'struct cred' that has a
proper allocator function normally.

I just removed the CONFIG_DEBUG_CREDENTIALS code, because the fix for
a potential overflow made it have bad padding, and rather than fix the
padding I thought it was better to just remove the long-unused debug
code that just made that thing even more unwieldly than it is.

But I thought that largely because our 'struct cred' use has been
quite stable for a long time (and the original impetus for all that
debug code was the long-ago switch to using the copy-on-write
behavior).

Let's not break that stability with suddenly having a "sometimes it's
allocated on the stack" model.

             Linus
