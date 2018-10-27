Return-Path: <jlayton@redhat.com>
Return-Path: <jlayton@redhat.com>
Message-ID: <b40f7fda3213c3f0c317386bb357d12ffb6d926a.camel@redhat.com>
Subject: Re: [PATCH v4 03/11] NFS: NFSD defining nl4_servers structure
 needed by both
From: Jeff Layton <jlayton@redhat.com>
Date: Sat, 27 Oct 2018 07:14:26 -0400
In-Reply-To: <20181026201057.36899-5-olga.kornievskaia@gmail.com>
References: <20181026201057.36899-1-olga.kornievskaia@gmail.com>
	 <20181026201057.36899-5-olga.kornievskaia@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Olga Kornievskaia <olga.kornievskaia@gmail.com>, trond.myklebust@hammerspace.com, anna.schumaker@netapp.com, viro@zeniv.linux.org.uk, smfrench@gmail.com, miklos@szeredi.hu
Cc: linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, 2018-10-26 at 16:10 -0400, Olga Kornievskaia wrote:
> From: Olga Kornievskaia <kolga@netapp.com>
> 
> These structures are needed by COPY_NOTIFY on the client and needed
> by the nfsd as well
> 
> Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
> ---
>  include/linux/nfs4.h | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/include/linux/nfs4.h b/include/linux/nfs4.h
> index 1b06f0b..4d76f87 100644
> --- a/include/linux/nfs4.h
> +++ b/include/linux/nfs4.h
> @@ -16,6 +16,7 @@
>  #include <linux/list.h>
>  #include <linux/uidgid.h>
>  #include <uapi/linux/nfs4.h>
> +#include <linux/sunrpc/msg_prot.h>
>  
>  enum nfs4_acl_whotype {
>  	NFS4_ACL_WHO_NAMED = 0,
> @@ -672,4 +673,27 @@ struct nfs4_op_map {
>  	} u;
>  };
>  
> +struct nfs42_netaddr {
> +	char		netid[RPCBIND_MAXNETIDLEN];
> +	char		addr[RPCBIND_MAXUADDRLEN + 1];
> +	u32		netid_len;
> +	u32 addr_len;

Could you fix the indentation above?

> +};
> +
> +enum netloc_type4 {
> +	NL4_NAME		= 1,
> +	NL4_URL			= 2,
> +	NL4_NETADDR		= 3,
> +};
> +
> +struct nl4_server {
> +	enum netloc_type4	nl4_type;
> +	union {
> +		struct { /* NL4_NAME, NL4_URL */
> +			int	nl4_str_sz;
> +			char	nl4_str[NFS4_OPAQUE_LIMIT + 1];
> +		};
> +		struct nfs42_netaddr	nl4_addr; /* NL4_NETADDR */
> +	} u;
> +};
>  #endif

Otherwise, looks fine.

Reviewed-by: Jeff Layton <jlayton@redhat.com>
