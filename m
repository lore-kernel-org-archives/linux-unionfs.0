Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793982961;
	b=2wqCbTFxpXjIipMh+CvzwyBN9l1VnGL9DPIna4AF5jT27M9INe6MmDnXwR6tU6eae8up
	 F70hQWcyXfqm8rRNHZDALZlXDXB0ZLv6rVqM1+ffHMnpEsFwRTPeZWnAZ/Nli3vDHTOTd
	 cR5WxBAsBtBN3S2/DtJLLU89CUm01ZzriziUA1/09s2K+qFDDMwmV0uwXfut6MqCdLaOA
	 9cEvm9XZC8JzkNzTpcYu+XcSycEVCLkVIQN/sCQAkbI1pljOemL+vlFMfChzdyjz4jcvL
	 5zitKGE/yZLSmvsHh9dEqPziB4WJkJ1DsPy745sO2Je72yQr6nhaalJofOkMBfcGD9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793982961;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=NcTmqhtV+CyerpPrIJMFx82gojPD5oXn6AN/59w3SY0=;
	b=oeuG6G3s9dAX0r5HhsNZrwMdEIKwkL8fTuW6gIUtFDSthLoQ4KllWJI0A8PDTh99Op3c
	 UtgKk0IooS0cg56V5gC5lIxwA8AYLLXcL+2wP7ifnPf9p/wPijMFcBcA6J4mH6b2n+zNB
	 yTkPMdj8GctZXhhZG1UbceVkHnJuo1QWHBS1vsCNpMVxv9ca46fbXdborAR7rYyt/fNO7
	 lXYPUnbDJEsrXY2fhkOjwLJLSCDXUY9PnEU1voNZ1Bmm0SfSr61E03p2ysDq668qccaz+
	 UFyNg/DCYCEnh5JQ2d+WH0Y8Q4Woas2xNx5kB3RufdsxqpvYOmhojti3EF9IGvl2HTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MkWZFNb4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5469F606A335;
	Fri,  6 Nov 2026 16:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MkWZFNb4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547221F0089F;
	Fri,  6 Nov 2026 16:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793982961;
	bh=NcTmqhtV+CyerpPrIJMFx82gojPD5oXn6AN/59w3SY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MkWZFNb4xmwd0VtHeGxP+9F37nOgiyusWLLeoJhGKPDl/OKsteIgBpOZ5aSF1nisu
	 icbwy/JAD2UmbQGo5r1zARSbiF958DDCKkl00AalQTQ7Nnk5XdL8f03O7UGoc6F8P2
	 5xALeM1i/KQ8z+2Zl2YrjyiiG1CwO+3iSVu2tej6OAcQBFIOGPyuXCc7qPaO9i7DUe
	 b5snuDhnNGtsfSZ07hPUDGk1smQJbFOMs0P1GAGSXU0kaCMRlqBrkV2YGUy0MRz4J2
	 Kx0pjt7ZTnuZr8UrmYYJ+YbqcLFFZ0W8yWxmOeh4aeQJec8g+EO+gvd7+i33bcIqhb
	 oQmC4YD+Cj7kw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	stable@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 6.1 1/3] ovl: check that the parents of volatile/dirty are dirs
Date: Fri,  6 Nov 2026 11:35:39 -0500
Message-ID: <2026-11-06-1-daily-reply-0004-ovl-series-6.1@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261106041128.3797453-1-amir73il@gmail.com>
References: <20261106041128.3797453-1-amir73il@gmail.com>
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

Queued the series for 6.1, thanks.

-- 
Thanks,
Sasha
