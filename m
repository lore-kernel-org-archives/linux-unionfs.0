Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED0B195
	for <linux-unionfs@vger.kernel.org>; Sat, 23 Nov 2024 17:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732382966; cv=none; b=PWo/ZKPhH5nw4IDIcNWR5wptDGO3A+34n9igwVCG3KPLJXuY3ZrqBioFy5rYuaAvM3kUtBZxWYhOH4I7lxUFjOcuPdae/4ptHY84jJDqOecNI5IZ6L3JV0r3bMFU2kWr9TTXv/5wEOyCg+i612jIr50GU2YrY3cHM/gIZ+AtJPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732382966; c=relaxed/simple;
	bh=JW0p9SO4wNjvfWYrh8A4OxTL6/rZR0ph+y4ILjPxPlY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r9CGhZj+b/Cgwaw72P6mj59ZXLPUZO7Ft2BHGjBpydvnok3rxIYujFUDGHUVNRUE3IEI6k0qoIrkQ14/DebXs/u3nIUqBCVsLxZjB1fIp5qw6OhyzqeDTejFWl5l38xqaacd3Lsm/f/cnhd7Wq9Lynrr1H2ADx1XE4LblDkmDFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IT4ULZFo; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IT4ULZFo"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-aa503cced42so277466766b.3
        for <linux-unionfs@vger.kernel.org>; Sat, 23 Nov 2024 09:29:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1732382963; x=1732987763; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5vCmemIQJAyBLtyohdE3n6qmf1JVeKEXVkWL++xifbs=;
        b=IT4ULZFoN22WvQ1hq5DfvRLu3WXEGh8N1xg1fHX5h99lox+dpGJu1qwIL31ZTENh6j
         ZKTkRz5Da3gOftWVyi4za9L66UGp1xcjqasFTDh21QXNCI67y3tAY2gygLjIAzh+u+QE
         kCI484fBTEwyoX84YytSMetUx/G5dzpY0LNtw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732382963; x=1732987763;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5vCmemIQJAyBLtyohdE3n6qmf1JVeKEXVkWL++xifbs=;
        b=h+gZeGgPQOY8OyDScVFBG+XP4E+kJnBzJmOh6XeRDy3Xt7ONJ0LjM7RZCC56/PG0Wg
         q2m1sQdFc69guOT1U46kMTIs9iA34HOa4akE2kN6mtnk9U3VveGBGvR7Pa/0fX5DOB3Y
         UMLM5eUqDTSof2thLu+6eHkBQMqOTWi39lE4nqfpLfFhkDGgzBDEr2TwgkEuBdQAig+h
         Ew9ypLWrjeIPX+sNgYaCmTybavrOgjcvtXSsxnz1I/4tkCmSZ+pwV1UKYMBNEai6LVJE
         TH8a+LujHHtZSJJMg1lzlgDgxNfbSvIdGsagsXs865d5Q8r5/d2KkknqlaZS9xa4E+WZ
         Kt3w==
X-Forwarded-Encrypted: i=1; AJvYcCXjR1PVec2dJ/SmiVvhzH/2H0FqFHrPNCs4fiAOZUB42HE8h56F7MpK+A8CEiAykGpObHgjPx8GytdO39az@vger.kernel.org
X-Gm-Message-State: AOJu0YwBw7vtZS+KHeICGy53mrkhkIRzIGw5z3jFt5f4MnS/Tjyts/N1
	8WDNOjDEnjwcKpdW58xiWAkGqlTSKcygm7yjE9dVbQDsLkcW7JSNNrYPhyefDdnNIg6Q27nGk8i
	QwBp9tw==
X-Gm-Gg: ASbGncuc//V7XIZpOhiARkxVEJDyKV91wDiDtPs+FiLxVLylXHZVJAd7RgvQsxyHvty
	EH08JFlnUo9gS+NOiDMrrKRazqWilnakAOgtmsrbyyX1DVN+XWrgtvQF43EXHD5TQLuf3jKRr14
	o6KndSYcLimWUvkWQdnGwdmVAjckrTeiILzi/lQtqHmGJITdliy+BQaDxjrLAgqM/p+kKBw6exW
	BCXdbXrjkbhEjUUZ8JgwN4l4vkv6vmxwNzbbTj0dnfmtaqP9RomgC9oJV3pnnCfCAopFRd62M6h
	z7/+u6DRAcquvXj9vNw5plgT
X-Google-Smtp-Source: AGHT+IFXvtyzx3ScnKqQt+0m9NaOUG3I4ZQ4EXUo/9JsMsQm0koSdPAXFfhBJDIdEdzKKbM25IXE6Q==
X-Received: by 2002:a17:907:781a:b0:aa5:396a:c9e8 with SMTP id a640c23a62f3a-aa5396acbbcmr165619466b.23.1732382962776;
        Sat, 23 Nov 2024 09:29:22 -0800 (PST)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com. [209.85.218.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa50b339612sm250098566b.84.2024.11.23.09.29.21
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Nov 2024 09:29:21 -0800 (PST)
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a9a0ec0a94fso456125666b.1
        for <linux-unionfs@vger.kernel.org>; Sat, 23 Nov 2024 09:29:21 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVM30NFIOiL0jZXNKixB6612oNyzLxYfMpKzEJEH9cSPl3U7a53JzimdtYN9jpBe0x4RdQDgHatSlvB7sbP@vger.kernel.org
X-Received: by 2002:a17:906:9d2:b0:a9a:13f8:60b9 with SMTP id
 a640c23a62f3a-aa509985a54mr597055366b.36.1732382961227; Sat, 23 Nov 2024
 09:29:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241122095746.198762-1-amir73il@gmail.com> <CAHk-=wg_Hbtk1oeghodpDMc5Pq24x=aaihBHedfubyCXbntEMw@mail.gmail.com>
 <20241123-bauhof-tischbein-579ff1db831a@brauner>
In-Reply-To: <20241123-bauhof-tischbein-579ff1db831a@brauner>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 23 Nov 2024 09:29:05 -0800
X-Gmail-Original-Message-ID: <CAHk-=whoEWma-c-ZTj=fpXtD+1EyYimW4TwqDV9FeUVVfzwang@mail.gmail.com>
Message-ID: <CAHk-=whoEWma-c-ZTj=fpXtD+1EyYimW4TwqDV9FeUVVfzwang@mail.gmail.com>
Subject: Re: [GIT PULL] overlayfs updates for 6.13
To: Christian Brauner <brauner@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 23 Nov 2024 at 04:06, Christian Brauner <brauner@kernel.org> wrote:
>
> So just to clarify when that issue was brought up I realized that the
> cred bump was a big deal for overlayfs but from a quick grep I didn't
> think for any of the other cases it really mattered that much.

Oh, I agree. It's probably not really a performance issue anywhere
else. I don't think this has really ever come up before.

So my "please convert everything to one single new model" is not
because I think that would help performance, but because I really hate
having two differently flawed models when I think one would do.

We have other situations where we really do have two or more different
interfaces for the "same" thing, with very special rules: things like
fget() vs fget_raw() vs fget_task() (and similar issues wrt fdget).

But I think those other situations have more _reason_ for them.

The whole "override_creds()" thing is _already_ such a special
operation, that I hate seeing two subtly different versions of the
interface, both with their own quirks.

Because the old interface really isn't some "perfectly tailored"
thing. Yes, the performance implications were a surprise to me and I
hadn't seen that before, but the "refcounting isn't wonderful" was
_not_ really a big surprise at all.

                        Linus
