Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793890726;
	b=etGz82xzy7ZMEW9vFMqxzdVGkbRG8WYIBfwAY2jUD6DrTYJk5MiLIUKGk2irHvcyu+5h
	 zfdVMitWfbVUFiTv249BbHunFQgVEWcx9LK0VjXBdggJi9ls1lPHp/LRBV2oqVlChiGRX
	 XaUHBNT1M68ZnVZkac4fYxeBlSc3fw1chk9y/Fsmwsk6xCjT30muNs3f5Pu0d2aOSLXGR
	 87V55Ao+AsQm8lkMtJC0MR6drt3+YZJ+YDwqivUOAWfskZjLb9RWVQYwYhrsEjzZdUYPK
	 GWUrtSA3zF9JwQU9UcXHpg+gz/yCr09AEHk1+XCz7wAy2rdbNETyg/rK8w16Na1smug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793890726;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=HiKTijl55RJ9mCgP7Q1hlrAgo8XqvO7WlmV/52OFCmg=;
	b=izMZ8U74+6+uJvLtunAtfqpGrpfKIFoKQJfReUXL8VlF3MJghMb50SvucbOl5kKflK7F
	 x699RC4X1MP1pWrKpOjv3GdrBRQoU4ZgZ0bt5UY9/GZPhwl4ivdzXIzydWZ5LMWGYXfEO
	 YnAeNCRvVmgcj4/BX7sz/HRAop0ItViOGbh8RPMJpAjhp3kxWB1SURXbtTXEkB8Lbx4nX
	 WAHxsiw8uCJQGSo/5wZF8YRCa1WQgeEKS5no7HAmBvdGM2bj1QUbKPReiO4aw/+ExQz2r
	 bu+kb4SvUX9s/XeeuHz2VVdlG7nkivHFz6hWPea9YIWJTfayx+4fN4WM0aPtPj6dQmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DDVwOwRr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5819E60A5BC2;
	Thu,  5 Nov 2026 14:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DDVwOwRr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75111F00A18;
	Thu,  5 Nov 2026 14:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793890726;
	bh=HiKTijl55RJ9mCgP7Q1hlrAgo8XqvO7WlmV/52OFCmg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DDVwOwRrj5sJOAmQwf1lVlADs87pEKbr0peOUl0N+oELzWoPb5aIlTQzmgC1jFhui
	 lP8LaEbX2pWZ6x1N+Cyf8svkZPiqW9hernO7riaP1zFxt9kS3If5XJFTJP+P2VUX5i
	 4cq6Wk0TPP5MH8qq+IBrU/5/l/rUfusZ7FH9eXQiLci5WHs7HDX06davrp/z6ur3K/
	 pUb1WGNyVitqQVPslgV5eaxojlPxi/s96ZzoOHiuFHgfJFUwcbQwK5yLo3wInh7+fz
	 wyTik//hzw3JnC1Wqj2bhUZt44pHWUQtWRyma+PMSNHt+CH6HX/Rpbr7HY/libgYsB
	 TYOsgcKZ4mduw==
Date: Thu, 5 Nov 2026 15:58:42 +0100
From: Christian Brauner <brauner@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Disha Goel <disgoel@linux.ibm.com>
Subject: Re: [PATCH] selftests/ovl: fix detached layer mountinfo expectations
Message-ID: <20261105-wurzel-innenansicht-wohnmobil-e1fb034e8c1a@brauner>
References: <20261017165103.2450042-1-amir73il@gmail.com>
 <20261030-pluspunkt-kreis-lawinen-274971662578@brauner>
 <CAOQ4uxhFFPq0tjbbZo=m2tGx=93Tat2hs5K3LJ_moW=Ca8o12g@mail.gmail.com>
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
In-Reply-To: <CAOQ4uxhFFPq0tjbbZo=m2tGx=93Tat2hs5K3LJ_moW=Ca8o12g@mail.gmail.com>

> This patch is already on ovl-fixes in linux-next of today.

But the fix is already in mainline. I think we got our wires crossed.
