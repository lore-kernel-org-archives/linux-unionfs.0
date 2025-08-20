Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D6C2E3B15;
	Wed, 20 Aug 2025 09:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755683006; cv=none; b=Giy8SplGNae6f7IHZy6jjLax7+dEwKF1cggjTh6TTJnGX5gzGt2E9YPWBzn73cpA277XJI+LxNXLbzKCWu4s9ebtraY4IHhyZ88itbC4MJhaLTiZFTfCoMI/nIUf03i5+EgHRuGRcku/gP/k1hByKdadgUpaIuqLkltFf7pvurA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755683006; c=relaxed/simple;
	bh=pZd0AyTtMW4T9v3lPr/fbHbSMmV1kbXFbKhPDmLPbGw=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=SVFjkdpsHO1YP72uIFhGD7dGGAzNNiQqRX8aICjUuqLMaqhpF0VQEJUng6GxdVlXr0/7ZDlPANbcQY5fMSaz7cnZ4ZrglPLtVA5If7r3z8BntxITpzWiGkYGmUWymePu3/iUCNU6pQCPWyfV/1q11hz+/4xxWdpsbTv6Wa0H1Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=iVd2/qN4; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="iVd2/qN4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1755682996; x=1756287796; i=markus.elfring@web.de;
	bh=9GUVOi4zaxWUubC0jqwvWk+ixLptFXpzUwHRUh/T7ws=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=iVd2/qN4X6Qu/6irZMw/q6GNcQUYPA8UgjKFwdTNWNMlImXR2k70SAJKCs+gvMws
	 AIZBRqSgZ/G3lByLOScZR5h8NKSyU5QA85MG9XJE5/028nX2ZHy5wfJJuODQ41WVU
	 AgGx2IpVga/is9U0S7rJwj32zdLsifKC7NZX8yAkXfEfc7cK5Jl+e4bMUpJ1lSQ+a
	 E0456/Y1+vruh8EMGh3nE+NqQmy05ukm92GsnAhyJff0eqCY6NC2gK2te0eyXmjzb
	 u+NmKvcMM5Wkwp4YdBHIIlxazovXDl7tNnoVaD06nfTo0weolIN9dBtUbu7x9JOWv
	 aGs7nVaA0V8lgUZaCA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.226]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1N5CUp-1uMraL2FJV-00yRGY; Wed, 20
 Aug 2025 11:43:16 +0200
Message-ID: <35d4fc68-fe57-464e-a651-eede49fbf00f@web.de>
Date: Wed, 20 Aug 2025 11:43:14 +0200
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: huhai@kylinos.cn, linux-unionfs@vger.kernel.org
Cc: hhtracer@gmail.com, LKML <linux-kernel@vger.kernel.org>,
 Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
References: <20250820092848.534-1-huhai@kylinos.cn>
Subject: Re: [PATCH] ovl: only assign err on error path
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20250820092848.534-1-huhai@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:PzeuRhRioR6tgeBL/sfrYJascYhrxYj/h2Oo5mmMxMOWUTloBE0
 Bo6ihD+yg3tPkBjynPNkwsSdYBqTgz3GU1J0V5OzyuF7S5N9snSDB6UO+bljVHaSqRm59WD
 iT62Y0BsAan6dkQQ1NNPbvHA1thDP96f2Ir4YNfgyNYL6AMAmjwSzREONrRgqeUA7KJXReJ
 3JTHcFuSjBulxlI9q5N8g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:/7yQa+xvO+0=;YzZME5+vx0MSkd24S6Z2CP9hfHc
 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
 9WzX9RA=

=E2=80=A6
> Signed-off-by: huhai <huhai@kylinos.cn>
> ---
>  fs/overlayfs/super.c | 2 +-
=E2=80=A6

Should the personal name be usually different from an email identifier
according to requirements of the Developer's Certificate of Origin?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.17-rc2#n436

Regards,
Markus
