Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20191030124431.11242-1-cgxu519@mykernel.net> <CAOQ4uxh670WFhwpQyPFTB2nUCSc9n1VmuyPOfdqiBSsq6GxLpQ@mail.gmail.com>
 <16e204de70e.cefd69461771.2205150443916624303@mykernel.net>
 <CAOQ4uxhdSXAvFQfhzZpBC=Xmmo9y+3AOU1o-tOWsLtr2ntU6Ag@mail.gmail.com> <16e20ebaea1.e98a5dc22147.7820959102365222617@mykernel.net>
In-Reply-To: <16e20ebaea1.e98a5dc22147.7820959102365222617@mykernel.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 31 Oct 2019 11:06:24 +0200
Message-ID: <CAOQ4uxihFu+ObkUxrZ3kzM1G5NrRauhgGxupuBarbAJaXSS_Zg@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: improving copy-up efficiency for big sparse file
Content-Type: text/plain; charset="UTF-8"
To: Chengguang Xu <cgxu519@mykernel.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>
List-ID: <linux-unionfs@vger.kernel.org>

>  > I did not explain myself well.
>  >
>  > This should be enough IMO:
>  >
>  > @@ -483,7 +483,7 @@ static int ovl_copy_up_inode(struct
>  > ovl_copy_up_ctx *c, struct dentry *temp)
>  >         }
>  >
>  >         inode_lock(temp->d_inode);
>  > -       if (c->metacopy)
>  > +       if (S_ISREG(c->stat.mode))
>  >                 err = ovl_set_size(temp, &c->stat);
>  >         if (!err)
>  >                 err = ovl_set_attr(temp, &c->stat);
>  >
>  > There is no special reason IMO to try to spare an unneeded ovl_set_size
>  > if it simplifies the code a bit.
>
> We can try this but I'm afraid that someone could complain
> we do unnecessary ovl_set_size() in the case of full copy-up
> or data-end file's copy-up.
>
>

There is no one to complain.
The cost of ovl_set_size() is insignificant compared to the cost of
copying data (unless I am missing something).
Please post a version as above and if Miklos finds it a problem,
we can add a boolean c->should_set_size to the copy up context, initialize
it: c->should_set_size = (S_ISREG(c->stat.mode) && c->stat.size)
and set it to false in case all data was copied.
I think that won't be necessary though.

Thanks,
Amir.
