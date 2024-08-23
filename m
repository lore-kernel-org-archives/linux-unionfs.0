Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2218618BBB6
	for <linux-unionfs@vger.kernel.org>; Fri, 23 Aug 2024 18:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724436290; cv=none; b=BURpFiiiiy0Un0mtLzuH2HRWpAf4KsSL/17LHEwZ8DAarTYYXaGlkmt4sFAkKpjd8bHLLuN+Wom4VRBczGW335ZM+1XAuvF6KKS6ZYUhvY2UFskw+Loo/ZnNxYtqYb+FmrMoQXETvye/pwkPKlwdDBsBFKxsLC/ovHmJDZfeYpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724436290; c=relaxed/simple;
	bh=AwiPlhBWfOHrPKfBfIdPmpppXr+7sJGMRvtavL9hLfI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UGQoeCCjPCXid5hmdBQXo2lvWYN45Y2hDgwY2154m8YsgdDV8KtcDlxPTdK0lDIYgNQxKXPPFGEKHcLVrpy5JZo6iSv+FuWg/hasTmfSariZqBJHi+nmWPkQLxvYIMfO4p486hXzYVadmwPecSodgRUvDkjw9pfBl605qEMWmCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K6l2v3bK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K6l2v3bK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1657C4AF11;
	Fri, 23 Aug 2024 18:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724436290;
	bh=AwiPlhBWfOHrPKfBfIdPmpppXr+7sJGMRvtavL9hLfI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K6l2v3bKHuS3836Qr/CPs/WjKF7sSQIgCQsGQczTOlwl5MrS2tyx0p1q5gTUcgqa+
	 x4DHDgPxzcZyWQe+O3VCsHzK4Be3Sjq2Bt5coiF78p30IMpAVpil3J4hImrwA7EvyZ
	 Wcs1EWDDo8ebqxDnHFmHf4rOSw1+iD7AOh7vgzVUvcdSyRqAJf7kLSsEXC8s4Bcdgr
	 3FaKlekzQLMPSR0LA9eSYkskZE3F8MmovEZWn60yDM0QYmdStTGvk/Yjl2osNo+JVT
	 K12VC5/iBkZ1FVzY509xNfgiVHQiQLa0LDyivD/zSTsjfd7Hf7d4CZUuWLkMvEO40G
	 T32R6L+zMUq2g==
Date: Fri, 23 Aug 2024 20:04:45 +0200
From: Christian Brauner <brauner@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Zhihao Cheng <chengzhihao1@huawei.com>, miklos@szeredi.hu, 
	linux-unionfs@vger.kernel.org
Subject: Re: [PATCH v3 3/3] ovl: ovl_parse_param_lowerdir: Add missed '\n'
 for pr_err
Message-ID: <20240823-backpulver-gegolten-5c77a9a89bfa@brauner>
References: <20240705011510.794025-1-chengzhihao1@huawei.com>
 <20240705011510.794025-4-chengzhihao1@huawei.com>
 <CAOQ4uxjs4Ffq1rO8X2F3xQtiHhUFRFtizfXTr5aKSh2wC43dFA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxjs4Ffq1rO8X2F3xQtiHhUFRFtizfXTr5aKSh2wC43dFA@mail.gmail.com>

On Fri, Aug 23, 2024 at 12:10:57PM GMT, Amir Goldstein wrote:
> On Fri, Jul 5, 2024 at 3:17 AM Zhihao Cheng <chengzhihao1@huawei.com> wrote:
> >
> > Add '\n' for pr_err in function ovl_parse_param_lowerdir(), which
> > ensures that error message is displayed at once.
> >
> > Fixes: b36a5780cb44 ("ovl: modify layer parameter parsing")
> > Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
> > ---
> >  fs/overlayfs/params.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
> > index 8dd834c7f291..657da705db25 100644
> > --- a/fs/overlayfs/params.c
> > +++ b/fs/overlayfs/params.c
> > @@ -493,7 +493,7 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
> >                          * there are no data layers.
> >                          */
> >                         if (ctx->nr_data > 0) {
> > -                               pr_err("regular lower layers cannot follow data lower layers");
> > +                               pr_err("regular lower layers cannot follow data lower layers\n");
> >                                 goto out_err;
> >                         }
> >
> > --
> > 2.39.2
> >
> 
> Christian,
> 
> Would you mind picking up this series via vfs tree?

Of course! Done now and pushed to vfs.fixes.
