Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AyeKu3YM"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B93D45
	for <linux-unionfs@vger.kernel.org>; Tue, 28 Nov 2023 07:11:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701184288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tZOFcC5ek1VA5I7PJdWsh/H/EHln3BsqHFA3D+DQWmM=;
	b=AyeKu3YMdbTqNplXwysRssWgCsLHVTcbLKVTZO+aSyPa8ORH1GoX+ZqTpj0JiNGBP6Ak8N
	i4KzqOOX7JemwUqmBcMLELuQ3bAjNaslrspVgm7ZSwo+Pz7U5Q59XWK/8y3pWWRMubMsXU
	cJLn/j+ARRyU9A9XOwPLeB1umt9kSKI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-110-GjRGvFxUOjCzalBm-7vQpg-1; Tue,
 28 Nov 2023 10:11:26 -0500
X-MC-Unique: GjRGvFxUOjCzalBm-7vQpg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 10B542806404;
	Tue, 28 Nov 2023 15:11:26 +0000 (UTC)
Received: from ws.net.home (unknown [10.45.225.94])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5ABE5492BFA;
	Tue, 28 Nov 2023 15:11:25 +0000 (UTC)
Date: Tue, 28 Nov 2023 16:11:23 +0100
From: Karel Zak <kzak@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	linux-unionfs@vger.kernel.org
Subject: Re: [PATCH] ovl: fix regression in showing lowerdir mount option
Message-ID: <20231128151123.3cnde47qum52vrxt@ws.net.home>
References: <CAJfpegsexQsNVMOZw+0byzj2wTbU_Tg6p0ATgwBAwmTaDmNbLA@mail.gmail.com>
 <CAOQ4uxjYGckJA=raAW8wyVmDaK-FXfFDRS0RCpZYcLucPqMi3w@mail.gmail.com>
 <CAJfpegt5COamxm-ZN+A9ub_Te-CPM0xMd-Rrzwv7OHBkvHS3yg@mail.gmail.com>
 <CAOQ4uxic3NDtEt9EiP+RYKGEB=6b_PCaudQA=cXK6mWY4Cmeqg@mail.gmail.com>
 <CAJfpegsr3A4YgF2YBevWa6n3=AcP7hNndG6EPMu3ncvV-AM71A@mail.gmail.com>
 <CAJfpegt7VC94KkRtb1dfHG8+4OzwPBLYqhtc8=QFUxpFJE+=RQ@mail.gmail.com>
 <CAOQ4uxhg+0_S1tQv9vUpv7Yu-VRLv7U7cnxLmxig+9LmS_qW+A@mail.gmail.com>
 <CAJfpegu6cESPijvO51zjVeXA=wcw7nMaNkkNJ7+my07wq8k9FA@mail.gmail.com>
 <CAOQ4uxicurA4nNeDkUarkTMujtsaOvwQ8HEMpz97N2SejBRx9Q@mail.gmail.com>
 <CAJfpegv=UXqYQzvH6+py76MV7+5L6=3a+_J7LpHQ0VK5YYrAUA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegv=UXqYQzvH6+py76MV7+5L6=3a+_J7LpHQ0VK5YYrAUA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

On Mon, Oct 16, 2023 at 03:10:33PM +0200, Miklos Szeredi wrote:
> Ah, but it's not a regression after all, since the kernel un-split the
> same commas until 6.5, so there was no way the libmount devs would
> have observed any regression in overlayfs mount.   But arguing about
> which component is the cause of the regression is not very productive.
> Indeed libmount can be fixed parse overlayfs options the same way as
> the kernel parsed them before 6.5, which is probably a much better
> fix, than a kernel one.
> 
> Karel, is doing such filesystem specific option handling feasible?
> 
> If so, then for overlayfs please please pass an un-escaped (\char ->
> char) string to fsconfig for "upperdir=" and "workdir=" options.

Committed to the libmount:
https://github.com/util-linux/util-linux/commit/f6c29efa929cb8c741591ab38061e7921d53a997

will be in util-linux v2.40 and in v2.39.3

It's implemented for all filesystems, not exception for overlayfs.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com

