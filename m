Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <CAOQ4uxgKDi7U1-z_KMB++WqagshEtcd0W-Q2kCAG3cXjsJNKzw@mail.gmail.com>
 <20181031141752.GB20169@redhat.com> <CAOQ4uxg9vFqM3G5aV456foRFSm9NpjkZoR6CddbTTdcWTN5Quw@mail.gmail.com>
 <20181031153944.GC20169@redhat.com> <CAOQ4uxjGWx02goXcBjqQAUv34N2QcnFLbDVaKykhYNhV71RNBQ@mail.gmail.com>
 <20181031163939.GD20169@redhat.com> <CAOQ4uxgLWHHK3RLE_zKXkM_S5Lfc7Hn2rpKvOvJda5RtE97C3Q@mail.gmail.com>
 <20181031192341.GA3093@redhat.com> <20181031195643.GA3382@redhat.com>
 <CAOQ4uxiCmmggC7_PTGS0Zw+GAL_xijSgTkAOOSSQGi-NAXEACw@mail.gmail.com> <20181031212419.GB3382@redhat.com>
In-Reply-To: <20181031212419.GB3382@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 1 Nov 2018 00:16:45 +0200
Message-ID: <CAOQ4uxiufacOJ7xf6oRPnBNS2nDOn=cEfzTvCdhwkvvZyTWgdw@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: return error on mount if metacopy cannot be enabled
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, "zhangyi (F)" <yi.zhang@huawei.com>
List-ID: <linux-unionfs@vger.kernel.org>

> I feel definition of "strict" has been expanding as we are discussing.
>
> - Initilaly, I thought that it only meant that any options specified
>   as mount option can'e be disabled and if system configuration does
>   not support it (for older mount options), we will fail mount.
>
> - Now it also means that Kconfig/module can lock down value of a
>   varibale and it can't be disabled from mount option (until and unless
>   user passes in strict=off).
>

I managed to confuse you. 'strict' doesn't mean that you cannot
change defaults with mount options at all.
It simply means that every instance of pr_warn("...falling back to")
is going to error instead of disabling a feature whose requirements
are not met.

Better wait for patches it will be clearer to read the code than my
emails...

> Have a quick question. Does backward compatibility applies even if
> both upper/ and workdir/ are empty. IOW, can't we automatically enable
> "strict" when we know that this is the first time overlayfs mount is
> being created (otherwise both upper and workdir will not have been empty)
> and we can enable strict policy without breaking backward compatibility.
>

I have already discussed this with Zhangyi in the context of "overlay
format v2".
There is not backward compat issue if both upper/work dirs are empty.

> /me is assuming that if a overlay mount has been successfuly mounted once,
> workdir will atleast have a subdir named "work".

The check for empty upper & work (including index) dirs should be done after
the cleanup of 'work' dir on mount.

Thanks,
Amir.
