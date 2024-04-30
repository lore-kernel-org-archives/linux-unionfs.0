Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE733EA83;
	Tue, 30 Apr 2024 07:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714463579; cv=none; b=QYidxXrNLIvACQQoRWVjwYIcjcroEo2RaTg2el+gZ/tS6/3EFe1ZflqaQIqkFOVGEU/bSF3kE+xMq8iyHVn//vJXv00S9QN9zkyI9gYPGNMMoCpKymCxw/OpS85Pr6AzP/CH5HiOM52ZZVPNab6A6Ru/FqT/2h0cofEMIfG9Bx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714463579; c=relaxed/simple;
	bh=xJVRBclfh8P+8hLG+1T8YfTZhmWHpBhetFNBinVd8eU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kUbD8SzzUuyOf1DZCFuEBJXIzH8ZcK2mCiTUPiIoE3XTH4vA1HSsYlRMihvSDmqd5ULWPCef6E/lju/pw5NYd+ciHaHuTvHF1WNB92JtEDzqHZHwA6Hy/8WMQYcEL6tvzIcxvyUGXq6f/I/x5Gm9CymSJer2R2xW2F0qXyMboNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qxfU2zBa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qxfU2zBa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC838C2BBFC;
	Tue, 30 Apr 2024 07:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714463579;
	bh=xJVRBclfh8P+8hLG+1T8YfTZhmWHpBhetFNBinVd8eU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qxfU2zBaHoy5EyBR2oheLZJMP1PyuAf8N4E/D6slFK0xBsknZRUsHBrDulxgwxci4
	 c7owR20uCYLyPfj6ngU64oqT172GOa8e3lBy0LIUpuFIjB/8/65M0/us4GoSD2n0BR
	 QdK7Lz9h64B36HRRmtYzTVMsRQH68e4P5LFe2ySo=
Date: Tue, 30 Apr 2024 09:52:56 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Jingbo Xu <jefflexu@linux.alibaba.com>
Cc: sashal@kernel.org, stable@vger.kernel.org, amir73il@gmail.com,
	linux-unionfs@vger.kernel.org
Subject: Re: [STABLE 6.6.y] ovl: fix memory leak in ovl_parse_param()
Message-ID: <2024043049-divisibly-discover-7a32@gregkh>
References: <20240430034854.126947-1-jefflexu@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430034854.126947-1-jefflexu@linux.alibaba.com>

On Tue, Apr 30, 2024 at 11:48:54AM +0800, Jingbo Xu wrote:
> From: Amir Goldstein <amir73il@gmail.com>
> 
> commit 37f32f52643869131ec01bb69bdf9f404f6109fb upstream.
> 
> On failure to parse parameters in ovl_parse_param_lowerdir(), it is
> necessary to update ctx->nr with the correct nr before using
> ovl_reset_lowerdirs() to release l->name.
> 
> Reported-and-tested-by: syzbot+26eedf3631650972f17c@syzkaller.appspotmail.com
> Fixes: c835110b588a ("ovl: remove unused code in lowerdir param parsing")
> Co-authored-by: Edward Adam Davis <eadavis@qq.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
> ---
> Commit c835110b588a ("ovl: remove unused code in lowerdir param
> parsing") was back ported to 6.6.y as a "Stable-dep-of" of commit
> 2824083db76c ("ovl: Always reject mounting over case-insensitive
> directories"), while omitting the fix for commit c835110b588a itself.
> Maybe that is because by the time commit 37f32f526438 (the fix) is merged
> into master branch, commit c835110b588a has not been back ported to 6.6.y
> yet.

Now queued up, thanks.

greg k-h
