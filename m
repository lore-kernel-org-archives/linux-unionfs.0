Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793959008;
	b=DDenmip8Vu85dodblsje2unxHpsji97iBYSb3s2KbIEDGSx3DWAt8nKh4SBti9I1nv8J
	 e9JeI0yLddSRvoXAPrUEUlTuq/igS/AHG7wBiHf9T780pXwiPOpFQHM1D+WPP0oL3eIn2
	 f2kgO3ZSXA+aVnruPOnBJRbjui7YDiY2GR9WmU/7PAtHSB67/IY0AX45kRe+0XSI2RCAK
	 1Pk4bD25qm+Rukr3pQAhOLvJr2oxHrwc78Vt/9jI1Wpqwp3tURbB9knJAlt7yTToR/5+b
	 uolG6GU8fEux8MdFxSXxF4ZEQfm+ghJPswDd4lqK0UGEp5Iqc402/fJzbmfzrcf9Qug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793959008;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=8rYKjadnk3L5Rz2sdZiwE2HJjQFgAIZLkKW3Se/Vlio=;
	b=qCLxua7wOyLpZW41gCwQg+1uePsrHxATN/93KzCA4hYvUHDeiS3ZmrWQdpmoE8aWno55
	 mRNT3dJatwLD8A28+wLgwpZYxaKAKDrYSw0MKsQsxTtGSqaJm0RUlzSgGh9bDEnrO00sH
	 dNiXBj5sWsUZ1jBlXCTvUJANegCCPxHP//tEqNX5xFcyegR9zGx0s4l7z5XFyXF2SA9ir
	 2sgnAWS8ze8HmktNH8b0IdaMI/dNNhGPbGU2OVpJr0Dk/4KEauFrZKz6A7oCawJWswTUI
	 3w03aAFI4FzUbqZvx05WNVAGa9iinC0/qvGAQDxoi3pQB0j3SLaRMo9YF7MG9QAeWiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i0BJXS8o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96987606A337;
	Fri,  6 Nov 2026 09:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i0BJXS8o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356801F008A6;
	Fri,  6 Nov 2026 09:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793959007;
	bh=8rYKjadnk3L5Rz2sdZiwE2HJjQFgAIZLkKW3Se/Vlio=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i0BJXS8ozGxBJTF/juHvXRYUv7atCQvntoanEOw+Wzpip+/pcwVT4MNZOCJ00Wtzv
	 2GKwDbWa0tAmAgxFJaivrTwtUiRQSlhjQ+6RQBf02qCHEmGFpmkKklHvVje4zUM8gh
	 P8OSPIY2bpi8Y+m5z2P2HHS4Zx3xjghAKMeAgSFmsg40JrZkIYRMhluxjK0mi+7xd+
	 J9SOwRqOP5hhe+1GRED9+fk5ADE8hkxlaxQiQ6FMGGUmRnmay0gJqiJqk/77q9iD5P
	 bML5yePY+Ey9pW7QEOOPehcx7lweOr8UkZv2mjl/SWHwoNmYKmPNZRANGFPsRu7aza
	 Ow2nYRxI3N1QQ==
Date: Fri, 6 Nov 2026 10:56:42 +0100
From: Christian Brauner <brauner@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Amir Goldstein <amir73il@gmail.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-kernel <linux-kernel@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Return failure from take_dentry_name_snapshot() (Was: [GIT PULL]
 overlayfs fixes for 7.3)
Message-ID: <20261106-geothermie-stier-animieren-67c9677d5906@brauner>
References: <20261031095716.3030288-1-amir73il@gmail.com>
 <CAHk-=wiPhTLn1p0ZHx-7SMdk4_zazqDK1k7MMEn9scRfqeDgtw@mail.gmail.com>
 <CAOQ4uxjNrdxZdZZipsqnUNq+TswCKqp+30iKRKCqh2WOQ-zKGA@mail.gmail.com>
 <CAHk-=wiimdwWu0EVQdxGVjbVWdzNKGg0f6vZ1aR-GXxDvQa-Eg@mail.gmail.com>
 <CAHk-=wjz+Tg3iq_6uBqxm+egP_aRhodcz2Qu3pQaR8SQcvPt0A@mail.gmail.com>
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wjz+Tg3iq_6uBqxm+egP_aRhodcz2Qu3pQaR8SQcvPt0A@mail.gmail.com>

On Tue, Nov 03, 2026 at 08:32:17AM -0800, Linus Torvalds wrote:
> On Sun, 1 Nov 2026 at 09:16, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > I'd like to see an ack from Al / Christian, but
> > I think I'll also rewrite that function to use guards.
> 
> I didn't get any acks, but I obviously did do the guard rewrite (and
> then some: I got a bit OCD about it).

VFS is just another acronym for OCD.

> I've committed the end result.

Thanks. Sorry, I didn't get to this earlier because of reasons... Well,
you know as you were on receiving end of it. In any case,

Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org>

retroactively.
