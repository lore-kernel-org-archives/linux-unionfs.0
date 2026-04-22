Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681C779CD;
	Wed, 22 Apr 2026 04:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776830789; cv=none; b=WS59ImsxDE3dmKWajeERjgS+xQzXeYemrsHwgE3Y9J+QCbE+JOykJKeH7ZwKg5JGlG+8tvLrvQ+5KMkqWvoXIPPl8PBEbHbVzDQzZepckJps/JlwDG79ybdLf+0cK2/zxvq+I9Gplb5yaBkVcK5O8ZveRi/NZmXfonp4YpgC2LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776830789; c=relaxed/simple;
	bh=hLrTaTWx9tcVhIwnpi3s08yRJPgbWh0HD3HGiUCwTEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mvoVkwWlikR4SXQTJraxPR+7grsTTp02JTZnxiq39Txf3M/NW+0zsKNLR4i9o6i3phd6ODoHENGjpqyKg2X8Wvo0hWNSqHVFnE/5TEMNYWm1iXghNtNBbZXOJRoEhAVvNwQmAQJbYSqvEMCWMQAa7wDJ5rNdk0pMIcisXWQB1sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=Job9woij; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="Job9woij"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KHiNmmoMCEB7iOCca1u7ljR8xi/J0NHOpHsykjR0d28=; b=Job9woijS0h2qgTwMn+K70XUrz
	SJKtdI5/7UylmdO3bHf6EZGaUJKv82qLdw/ZOK2h+whXKUPNq3wwq4IPXFr2iybUOo64Z/RRD7gHY
	jfBaRmPkmwDMYQECvL3p/l+OMAcpeZv5yhX0ZggZrNMoykR54n807UH9NG8QoJxTDuUuG1GCwDHCZ
	rpFu5Bp0UlRKy844QCEG8fGz353hND3jM+zs3Oofsg73puhNieBdHXDmDcT7VwA0Itkt6SPEmCROg
	ZU0rIDD30vfpt9M4kXWSgYjeXaOJszM90vPFAeVK9Xt5Uo0fy9py7QLAjh17yjuzy2vcqsz78Dfwi
	VM8heguA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wFOv2-00000005R9s-38wV;
	Wed, 22 Apr 2026 04:10:32 +0000
Date: Wed, 22 Apr 2026 05:10:32 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: sunliming@linux.dev
Cc: miklos@szeredi.hu, amir73il@gmail.com, linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, sunliming <sunliming@kylinos.cn>
Subject: Re: [PATCH] ovl: Fix possible NULL pointer dereference in
 ovl_destroy_inode
Message-ID: <20260422041032.GH3518998@ZenIV>
References: <20260421092349.148002-1-sunliming@linux.dev>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421092349.148002-1-sunliming@linux.dev>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Tue, Apr 21, 2026 at 05:23:49PM +0800, sunliming@linux.dev wrote:
> From: sunliming <sunliming@kylinos.cn>
> 
> In the ovl_destroy_inode function, a variable reference oi->lowerdata_redirect
> that might be NULL is directly freed. Add a non-null check, and only free
> the space when it is not NULL.

Which NULL pointer dereferencing is that change supposed to prevent?  If oi is
NULL, your condition would have exact same NULL pointer dereference (as would
several places in earlier lines, while we are at it).

And kfree(NULL) is NOT dereferencing anything; it's explicitly defined as
an empty operation, same as for userland free(NULL) and for the same reason.
