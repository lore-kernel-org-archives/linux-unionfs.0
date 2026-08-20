Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5095847F2CE
	for <linux-unionfs@vger.kernel.org>; Thu, 20 Aug 2026 17:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248222; cv=none; b=HgR7/PGdCAWnseyndbi+CZrzKaf2BOVgY/NGTc9YbYV7Nl9QgmhsZF5krke7QOdONLF03nm9LP1nGSpyirLTcggW9/5xfyL9zmCMtzkhM0MIZ2yaKl2/9Er5JHv8y8GG51h2jbhK6jJy0/kM4x2pSiMf8JYdf5Dv6BVNvJtQlSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248222; c=relaxed/simple;
	bh=azL6pMfssI+o4ECBFo82B22ejlVXeit8z7j5FK+aJfA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mOVIJi6HFb9B9L8TxbyL8aFRssTbNSW1xdI9LHzl0QgfOxbsEd2GJzLtBfQ+U0hkenzAPgOAPMECUte74ngrt/0vH1tRqIvBFW9aPTaEjRtnlv8xnDejWo4Xb+CqPg7qDjHhMy5+3G9zyL31vfixX1v+fQ53921xb3+K/j2rlWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EKXuBNHU; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EKXuBNHU"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5b2a4359d16so100662e87.3
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Aug 2026 10:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787248219; x=1787853019; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9jFMUvzYyyAGffP4UVV5ruK5O8NFOvkXY87WGr65ihE=;
        b=EKXuBNHUhQabJzXgvkEafdwQxBYUfaB8PCYxTWoXW5+SJTPQcDSJiAaOiE8TwcPI2G
         9GQBntgiatGHZQtjpC72sClJe6UldGgTDYyUaZHl7VSRmZEs4pUZBzCynYn373dRpH4/
         whSIPpmNh+WmH7i1BE/lCxCa08LLJYjs4hU4MZOWn2NnTUUpglQXeuCPmsmFKQp+FjT6
         RfpJGHoXV3wrnR/v+R9/UeCcZoWDCjkm2w/d/jiqM2n5lQduGxTF+lvT6/RtVGt9YYx7
         B0qWRE/80rP1a9GvBEU1Xuk2AtFtBrT/w5dRchJsouqdFuA+cHJhP9rMygbb6PagM4hS
         3I6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787248219; x=1787853019;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9jFMUvzYyyAGffP4UVV5ruK5O8NFOvkXY87WGr65ihE=;
        b=iy4ML8ADXzL2nJKV7QdfoKTOEe1RozIRvwDnSmmha8Ufi25gEZAVHMmq2bmcWL1fCD
         iDby23rVAut8ifH8Ir6LttW86msgHxjMZus/rF/StS5jeJb4/vBp6uNK2fGVeW0j8L+7
         O0UFVwO/F4GzdVZ/iII1l5rIjqMFNAyyvp8bAhkq/Qk86sZ13VFbbj2K6GKTZ5lWlGeL
         kiY8gR8xL3YymbnnJADoNCEqAhh8aXmeVtiP1kaDg3hseRJgFVrY+NP2mtTRKr4Rc93q
         Topuc19FudQaJLghroPdxWzm8c605ZAprcReyPaJ+YUI2BSxH/Xfr/ITVmsvcklDJqHg
         qk0w==
X-Forwarded-Encrypted: i=1; AHgh+Rroqif6mX4uHBXvmp6TY2TDQZjl0waoTqdoAmHiDrIbeO+QN7C7wTHDA4oCxU/4BTuNHzhq6MYIvo3UMXIn@vger.kernel.org
X-Gm-Message-State: AFuF++k5EqAeicu5KKc0z2IoPC04leC/Yox2P9ZJFiS79thfHiwi/0X4
	oJUqYIbsMqY8tksnn0CAUajeoBwvrxqPY9+hiVyOXg1+cET/rIm1o/Q6
X-Gm-Gg: AR+sD11Zmrt986IXZS/MOr4gUy/aLh5HfZPiJkGAwSPm5RTmRfiCYzGpTL9mWV0/AAV
	sBRVgOBkpbZ5Mi1skdECK6PBO4AOnsDBaccss0HUN1PFGSo3Z9STZyFdCL0OEb+0R/5CvokkBz1
	r7/m0HyjKVwOxxQfIoxCgeLG6SGb4fDJhNo833MYIYqq+roQek+jFjk9IIRXwL8hjbOBanm1UAH
	P3agYxhynzd34CN1FWrhmgcYEZe+1xjPQAOe50PnVJIi68853llQt1lhpO+5YWfi/dK6Fcxf13j
	n68kWFKVjOvaxe7ATXf1cNnrzeFkftMgxUY2HWG9KmCEFPeVvUsnhfv0d1sgxfGzM2h9Ro0xUAF
	HOyqCdt7hAS3lImtCOjcDD4/szZg69i2WPEnSkLJAz16QIaCaqXZPC1/IQ9uJLQ6aGs1Cn/O0WT
	5dL8FVwevXsrF2DB7motn8z55JvnWheB/inEzIbqQkQmGsFbjZo5tpO5IVvEtWMn230sR1Vyd+g
	BCZjoi8v/QJNoIvMiToL66etHqT4wyvt9Xml5+GrJTCbLw23mf4R1lcCMOdqUOeWbmXB8AXuUL9
	5LXlpuf4jLUJuUHPmWe7W4qRVvuj2MbGH7kvsRgeOQStjJkHtGMTP29dGMZL6lIgy9cEbl4=
X-Received: by 2002:a05:6512:304e:b0:5b0:22a6:6b13 with SMTP id 2adb3069b0e04-5b48408197amr57328e87.0.1787248219056;
        Thu, 20 Aug 2026 10:50:19 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-2a02-3100-a476-1a01-141e-2b69-987c-d72d.310.pool.telefonica.de. [2a02:3100:a476:1a01:141e:2b69:987c:d72d])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b478860c85sm1419706e87.35.2026.08.20.10.50.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 10:50:18 -0700 (PDT)
Date: Thu, 20 Aug 2026 19:50:16 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: selinux@vger.kernel.org, Paul Moore <paul@paul-moore.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH] selinux: preserve user SID across nested backing files
Message-ID: <aoc9pAzSVOzCaHS5@gmail.com>
References: <20260820061349.10542-1-kmehltretter@gmail.com>
 <CAOQ4uxhgMNvFxauLzm2PQif_D164+rJqmGdU5T+XDfhMJTVJnA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhgMNvFxauLzm2PQif_D164+rJqmGdU5T+XDfhMJTVJnA@mail.gmail.com>

On Thu, Aug 20, 2026 at 04:32:28PM +0100, Amir Goldstein wrote:
> Sigh, this is so confusing.
> 
> The fix looks correct to me but I would use a helper selinux_user_file() akin
> to file_user_path() instead of open coding the condition above.
> 

Good idea. I initially had a helper and should have kept it.

I'll send a v2.

Thanks,
Karl
