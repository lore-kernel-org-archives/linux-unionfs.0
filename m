Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A024DC54FB9
	for <linux-unionfs@archiver.kernel.org>; Fri, 17 Nov 2023 19:46:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbjKQTq1 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 17 Nov 2023 14:46:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbjKQTq0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 17 Nov 2023 14:46:26 -0500
Received: from mail-yw1-x1144.google.com (mail-yw1-x1144.google.com [IPv6:2607:f8b0:4864:20::1144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E60D5D
        for <linux-unionfs@vger.kernel.org>; Fri, 17 Nov 2023 11:46:23 -0800 (PST)
Received: by mail-yw1-x1144.google.com with SMTP id 00721157ae682-59b5484fbe6so25860647b3.1
        for <linux-unionfs@vger.kernel.org>; Fri, 17 Nov 2023 11:46:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1700250383; x=1700855183; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8HiXFxNzkgDQqIi9mZHfI8ZXXqorfkGFibjAEXC4M58=;
        b=010YzRDJophKRF+yqc3/UzJ55XINqI0jIl0j1AkZwDKlcMJA+3oA/t8wOeTd7sKppx
         Irvdr4QzeP9lRaqpcjDrlWst569Nw1TeIDqRzAxxc1700MPjke3TTCD+3DLfjCYK1NKe
         xe9ZnhS8OArBSxiJgqtu5zJZgudTPDHMjr4iaj3aRIlPgl5SQYfWxp9i3KEXKX1jWM3o
         il6+WpP3eU2nn1KvGawFSYJuGa5D0RjmQUEivmTZyA/7Dq/HZ7LdIUsYV+b01iH6lESD
         cN/DXahEAs/gcoPOfbME17uniy8Ew/V8eWanxN6IofhsYgN3B3AzBRc1SRVJxU2XOQ+x
         m5hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700250383; x=1700855183;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8HiXFxNzkgDQqIi9mZHfI8ZXXqorfkGFibjAEXC4M58=;
        b=QF3zquPCtpTicS4NdmhxQqwwU/OiMt3BH+gYev8i4obwlQXbHVcQJWJgzfPD0+43Qr
         TI9GvJ0JuMDLRn9507+Hm2VZ+/uUFlozexKRQrCLnOGsWVNNxP61NtCBfusATKDVDW48
         tzEx8ahi7wl4b/WBQl1rVy4W8PfHvi3qO/4SRfBjzchnj4DdYADXjS+milEkYHO6+5m+
         M+JCxaQBeKdPMef6jJlacs/oTJ27RO9g7DPLIq3dzeSHGMGvql4HeUCQdLlztXUcrg/1
         GDYKFcuYy5LztaqKJU5g6gsLVfYwDGeHETkQKUheKE35nadv4hZpfjR4q7akiF9HewwD
         74KQ==
X-Gm-Message-State: AOJu0Yz7Ja7ujDF18MwdV8aETyDHhZcXijbF0QcogH4W6viC/WvtCUbg
        kBSt0nq5RtCNzg1Bp9UTUXwx8fS8uo3XMjWs2C1JpMmwie8=
X-Google-Smtp-Source: AGHT+IE5pje/WHlZIKhALhqkLmDtbBPzK7JuXSTTVoFeODjPu1m/bDGPhMasawqbFdr/xpWaVV2XpQ==
X-Received: by 2002:a81:8082:0:b0:5a8:1d75:65c3 with SMTP id q124-20020a818082000000b005a81d7565c3mr712166ywf.13.1700250382961;
        Fri, 17 Nov 2023 11:46:22 -0800 (PST)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id z6-20020a818906000000b00594fb0e2db3sm656968ywf.138.2023.11.17.11.46.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Nov 2023 11:46:22 -0800 (PST)
Date:   Fri, 17 Nov 2023 14:46:22 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 12/15] fs: move kiocb_start_write() into
 vfs_iocb_iter_write()
Message-ID: <20231117194622.GD1513185@perftesting>
References: <20231114153254.1715969-1-amir73il@gmail.com>
 <20231114153254.1715969-13-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231114153254.1715969-13-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Nov 14, 2023 at 05:32:51PM +0200, Amir Goldstein wrote:
> In vfs code, sb_start_write() is usually called after the permission hook
> in rw_verify_area().  vfs_iocb_iter_write() is an exception to this rule,
> where kiocb_start_write() is called by its callers.
> 
> Move kiocb_start_write() from the callers into vfs_iocb_iter_write()
> after the rw_verify_area() checks, to make them "start-write-safe".
> 
> This is needed for fanotify "pre content" events.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/cachefiles/io.c  | 2 --
>  fs/overlayfs/file.c | 1 -
>  fs/read_write.c     | 2 ++
>  3 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/cachefiles/io.c b/fs/cachefiles/io.c
> index 009d23cd435b..3d3667807636 100644
> --- a/fs/cachefiles/io.c
> +++ b/fs/cachefiles/io.c
> @@ -319,8 +319,6 @@ int __cachefiles_write(struct cachefiles_object *object,
>  		ki->iocb.ki_complete = cachefiles_write_complete;
>  	atomic_long_add(ki->b_writing, &cache->b_writing);
>  
> -	kiocb_start_write(&ki->iocb);
> -

This bit is subtly wrong, there's a little bit below that does

        ret = cachefiles_inject_write_error();
        if (ret == 0)
                ret = vfs_iocb_iter_write(file, &ki->iocb, iter);

If cachefiles_inject_write_error() returns non-zero it'll fallthrough below and
call cachefiles_write_complete() and complete the kiocb that hasn't started yet.
Thanks,

Josef
