Return-Path: <olga.kornievskaia@gmail.com>
MIME-Version: 1.0
References: <20181026201057.36899-1-olga.kornievskaia@gmail.com>
 <20181026201057.36899-5-olga.kornievskaia@gmail.com> <b40f7fda3213c3f0c317386bb357d12ffb6d926a.camel@redhat.com>
In-Reply-To: <b40f7fda3213c3f0c317386bb357d12ffb6d926a.camel@redhat.com>
From: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Date: Mon, 29 Oct 2018 10:28:53 -0400
Message-ID: <CAN-5tyEBFzM6vrMdAqo1amOfmdPoVpD3wvTtMnALMOa4EtuhhA@mail.gmail.com>
Subject: Re: [PATCH v4 03/11] NFS: NFSD defining nl4_servers structure needed
 by both
Content-Type: text/plain; charset="UTF-8"
To: Jeff Layton <jlayton@redhat.com>
Cc: trond.myklebust@hammerspace.com, Anna Schumaker <anna.schumaker@netapp.com>, viro@zeniv.linux.org.uk, Steve French <smfrench@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-nfs <linux-nfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Oct 27, 2018 at 7:14 AM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Fri, 2018-10-26 at 16:10 -0400, Olga Kornievskaia wrote:
> > From: Olga Kornievskaia <kolga@netapp.com>
> >
> > These structures are needed by COPY_NOTIFY on the client and needed
> > by the nfsd as well
> >
> > Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
> > ---
> >  include/linux/nfs4.h | 24 ++++++++++++++++++++++++
> >  1 file changed, 24 insertions(+)
> >
> > diff --git a/include/linux/nfs4.h b/include/linux/nfs4.h
> > index 1b06f0b..4d76f87 100644
> > --- a/include/linux/nfs4.h
> > +++ b/include/linux/nfs4.h
> > @@ -16,6 +16,7 @@
> >  #include <linux/list.h>
> >  #include <linux/uidgid.h>
> >  #include <uapi/linux/nfs4.h>
> > +#include <linux/sunrpc/msg_prot.h>
> >
> >  enum nfs4_acl_whotype {
> >       NFS4_ACL_WHO_NAMED = 0,
> > @@ -672,4 +673,27 @@ struct nfs4_op_map {
> >       } u;
> >  };
> >
> > +struct nfs42_netaddr {
> > +     char            netid[RPCBIND_MAXNETIDLEN];
> > +     char            addr[RPCBIND_MAXUADDRLEN + 1];
> > +     u32             netid_len;
> > +     u32 addr_len;
>
> Could you fix the indentation above?

Will do.

>
> > +};
> > +
> > +enum netloc_type4 {
> > +     NL4_NAME                = 1,
> > +     NL4_URL                 = 2,
> > +     NL4_NETADDR             = 3,
> > +};
> > +
> > +struct nl4_server {
> > +     enum netloc_type4       nl4_type;
> > +     union {
> > +             struct { /* NL4_NAME, NL4_URL */
> > +                     int     nl4_str_sz;
> > +                     char    nl4_str[NFS4_OPAQUE_LIMIT + 1];
> > +             };
> > +             struct nfs42_netaddr    nl4_addr; /* NL4_NETADDR */
> > +     } u;
> > +};
> >  #endif
>
> Otherwise, looks fine.
>
> Reviewed-by: Jeff Layton <jlayton@redhat.com>
>
