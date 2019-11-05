From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v15 1/4] Add flags option to get xattr method
 paired to __vfs_getxattr
Date: Tue, 5 Nov 2019 10:48:30 +0100
Message-ID: <20191105094830.GL22379@quack2.suse.cz>
References: <20191104215253.141818-1-salyzyn@android.com>
 <20191104215253.141818-2-salyzyn@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20191104215253.141818-2-salyzyn@android.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Mark Salyzyn <salyzyn@android.com>
Cc: Latchesar Ionkov <lucho@ionkov.net>, Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, Jan Kara <jack@suse.cz>, linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Martin Brandenburg <martin@omnibond.com>, samba-technical@lists.samba.org, Dominique Martinet <asmadeus@codewreck.org>, Artem Bityutskiy <dedekind1@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>, David Howells <dhowells@redhat.com>, Chris Mason <clm@fb.com>, "David S. Miller" <davem@davemloft.net>, Andreas Dilger <adilger.kernel@dilger.ca>, Eric Paris <eparis@parisplace.org>, Mauro Carvalho Chehab <mchehab+samsung@kernel.org>, netdev@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-afs@lists.infradead.org, Mike Marshall <hubcap@omnibond.com>, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.orgAndreas
List-Id: linux-unionfs@vger.kernel.org

> @@ -228,11 +228,11 @@ static int afs_xattr_get_yfs(const struct xattr_handler *handler,
>  		break;
>  	case 1:
>  		data = buf;
> -		dsize = snprintf(buf, sizeof(buf), "%u", yacl->inherit_flag);
> +		dsize = scnprintf(buf, sizeof(buf), "%u", yacl->inherit_flag);
>  		break;
>  	case 2:
>  		data = buf;
> -		dsize = snprintf(buf, sizeof(buf), "%u", yacl->num_cleaned);
> +		dsize = scnprintf(buf, sizeof(buf), "%u", yacl->num_cleaned);
>  		break;
>  	case 3:

These scnprintf() changes (and there are more in the patch) probably
shouldn't be here... Otherwise the patch still looks good to me :).

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
