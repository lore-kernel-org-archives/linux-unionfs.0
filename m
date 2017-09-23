From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH] ovl: Return -ENOMEM if an allocation fails ovl_lookup()
Date: Sat, 23 Sep 2017 09:11:41 +0530
Message-ID: <1680634.zEmtb0eVgD@localhost.localdomain>
References: <20170922204518.cqagl2vlh7jiwt6y@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33840 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751832AbdIWDlA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 22 Sep 2017 23:41:00 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8N3cvLo137016
        for <linux-unionfs@vger.kernel.org>; Fri, 22 Sep 2017 23:40:59 -0400
Received: from e23smtp04.au.ibm.com (e23smtp04.au.ibm.com [202.81.31.146])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2d59m2vmay-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Fri, 22 Sep 2017 23:40:59 -0400
Received: from localhost
        by e23smtp04.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Sat, 23 Sep 2017 13:40:56 +1000
In-Reply-To: <20170922204518.cqagl2vlh7jiwt6y@mwanda>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, kernel-janitors@vger.kernel.org

On Saturday, September 23, 2017 2:15:18 AM IST Dan Carpenter wrote:
> The error code is missing here so it means we return ERR_PTR(0) or NULL.
> The other error paths all return an error code so this probably should
> as well.
> 
> Fixes: 02b69b284cd7 ("ovl: lookup redirects")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index c3addd1114f1..beb8a988df51 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -634,6 +634,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>  		}
> 
>  		if (d.redirect) {
> +			err = -ENOMEM;
>  			upperredirect = kstrdup(d.redirect, GFP_KERNEL);
>  			if (!upperredirect)
>  				goto out_put_upper;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

The patch looks good.

Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

-- 
chandan
