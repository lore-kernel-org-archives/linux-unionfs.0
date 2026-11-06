Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793982964;
	b=rGIIH3CB775g4FmmMZtV0wGRjm3u/07SEQ5S2VdrrWzZqxRlMphLqrACMrviU8UGcMvK
	 Jbw3RAxYseJD15rDhmPoQNyvFOsSe1D2KaNJFp5neI+3J7sq/H2QOjHEyUxq/OClBAGO5
	 bWtkRD0+Jaqfv8W7rcZWDXIP/YqRCrUEWxf04N2nyDQhlB2RXrQKnNh8ZqOFG60yHhTge
	 T+jCFVqjWag6FlDp1FFgGdr6yDOYDakc0OhKKrsIw1ItqXFkFne7PgNYpNX0A1RJMtySz
	 r8XliJtgmPktpeeOKdI2DWavMfJivjUB6zdvXmd9yVfJmz+mz5N35XJumcNSa3VPwvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793982964;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=78QGvAUPdC8R8OFrSbLa501xwwR1r5Y7sWmSj9FUrrY=;
	b=H5tAB1QfrtJx/L+Lvj7hfc9HaaLIoolrcf81X6GnzNnUf70pL0UdLwKo3KKRarxkS5Zy
	 31WEogU6K5HIEQd4cWxGXVoDOsCDiVJK3X+75oQzM1BFCPneXTrpJXJUeN8vE8eatGDyq
	 VmaJXWfARlS0KrTDNsSPNvQRfqsusUBGdH7mGjf4+M7tii+y1VRShtn1wbhpF9im1MOI3
	 BnFQV5IJh0X8A3Sn5ssYmJ0QRbK9E/KHI9Uu6iyLV/i/Pq5+ieghmX4X6wGUyRBBr6Pe0
	 kj81EkjzWzzuoXaQy7tnW3Ell1aamqLIJAwLU3s0oMk6tD9V2k7y73MilcnBvCgR0fA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jb0blcee;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0256606D803;
	Fri,  6 Nov 2026 16:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jb0blcee
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92FD11F008A1;
	Fri,  6 Nov 2026 16:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793982963;
	bh=78QGvAUPdC8R8OFrSbLa501xwwR1r5Y7sWmSj9FUrrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jb0blceeiBqQ5lH6I1WCPz+gQ0mWr+//9a9tvf2CvvgZlMjNvmUP+4K2kEnkfLAZ7
	 i5rJTerSq2jG/CWxTNWaDy7TyAUgdJdmSlobqkfcMvNCDXACncmLN9KIZO8Y9hiwGz
	 2qopx+UubTGrVHlz+xSBezRKrr55H2wzL5Z6tbHtLRCdUN4DCIZsMbm/en28pKm3GO
	 wJQR3aRNJ09+Ydz0iv3rbr8V6VRv6QIUq6QPhqqhH9lL+422jt0kqVss92nMmWL50j
	 Fkwih0wl77tpYYkVwSH4WEsvPylsf6uK+1kYR0ZT0ze9eDsZRvKJwDoBCFFf9uwF5F
	 Y1TV7qHizAWjg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	stable@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 6.6 1/3] ovl: check that the parents of volatile/dirty are dirs
Date: Fri,  6 Nov 2026 11:35:41 -0500
Message-ID: <2026-11-06-1-daily-reply-0006-ovl-series-6.6@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261106041128.3797453-7-amir73il@gmail.com>
References: <20261106041128.3797453-7-amir73il@gmail.com>
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> ovl: check that the parents of volatile/dirty are dirs

Queued the series for 6.6, thanks.

-- 
Thanks,
Sasha
