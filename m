Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F34640A92F;
	Mon, 12 Oct 2026 10:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791801922; cv=none; b=Y2Hvd7Y1jKLiEZZHiQbbvDgPD0SRYS7Lk/EDmdtpZoU3kGnaIIDkDAwVVfcATrattuxoUe9v0SWWcjVC71ZwdSaZifxam10L0yDxjuxhEH6lKzI9245pT2SheaGNSeOSh9Th/2khLMkQlG7uK/Rx9vDEgaz2Z46oBrvUl4wYogI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791801922; c=relaxed/simple;
	bh=5r4cSAbFM6PJhzbgFA4LDhA2CYPlVWNFxnbQ7IAMxUo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f39gVhJ16lPhEjSxK8IwcDDuNkENPl/BH/tt5ulq9ttQiVrjvbnUrscnDRVLZ/oCAOcAWP/3yroRPBX3e7Wd/3rqRC8ma2uBZwdscoGQO/+4LvZ29vxbC2Eo1A8HHxMudMTMIU4WhlU2lD4fOHGWmDBBVkbS18NmTmvCAIwSs98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XclzyMhY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XclzyMhY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D831F0089B;
	Mon, 12 Oct 2026 10:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791801920;
	bh=5DWG3MKFZ05brWsnZeZmUAZ4l6ctkPA3YEjKuIuQkAg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XclzyMhYo1ra1vjOsjOGNHunp7CASf95HjlMW+2IRL5jtwDE96ZLtPfmLz3Z0iF5V
	 GDKi3bzsoCSyK9qUjUGkZApEZt4X3ePHu+PLH1ydS6aQLmizUxlVWcy+306SOKzsOz
	 /j1ngWwEZ+48oyBPCFqu7l351Lw+1TAZYaZvNUPu6A+PnvcXgVy/di6Oc07+++h7wM
	 FTUH80xo46f5VmqTEnOmbTmy/9dhSgb5fT6rQKYNGf/w+Cyi84MMaGEkJzGmbaWeNM
	 /OX7JLu2Ub+l1cbxP/cwlAoYfIH1c/vlIijuqZfad76yR1wx9sWMZjTRPsifupT8Z8
	 uPloTNY9VeF4Q==
Date: Mon, 12 Oct 2026 12:45:16 +0200
From: Christian Brauner <brauner@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Guanglei Zhu <zhugl3@xiaopeng.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, liuwb@xiaopeng.com
Subject: Re: [PATCH v2] ovl: reject lowerdir ending with unescaped backslash
Message-ID: <20261012-dreht-merkbar-abstrahiert-13a68ad2c9c7@brauner>
References: <20261012060847.836027-1-zhugl3@xiaopeng.com>
 <20261012095538.938789-1-zhugl3@xiaopeng.com>
 <CAOQ4uxgLZWGFhSHfHWiGFau7ZOXmNWsd8M5iVTOf+4_hO2KgGA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgLZWGFhSHfHWiGFau7ZOXmNWsd8M5iVTOf+4_hO2KgGA@mail.gmail.com>

> Christian,
> 
> Could you pick this up via vfs.fixes?

In vfs.fixes now. Thanks!
