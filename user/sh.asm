
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	add	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	add	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  fprintf(2, "$ ");
      10:	00001597          	auipc	a1,0x1
      14:	2d058593          	add	a1,a1,720 # 12e0 <malloc+0xe6>
      18:	4509                	li	a0,2
      1a:	00001097          	auipc	ra,0x1
      1e:	0fa080e7          	jalr	250(ra) # 1114 <fprintf>
  memset(buf, 0, nbuf);
      22:	864a                	mv	a2,s2
      24:	4581                	li	a1,0
      26:	8526                	mv	a0,s1
      28:	00001097          	auipc	ra,0x1
      2c:	bb8080e7          	jalr	-1096(ra) # be0 <memset>
  gets(buf, nbuf);
      30:	85ca                	mv	a1,s2
      32:	8526                	mv	a0,s1
      34:	00001097          	auipc	ra,0x1
      38:	bf2080e7          	jalr	-1038(ra) # c26 <gets>
  if(buf[0] == 0) // EOF
      3c:	0004c503          	lbu	a0,0(s1)
      40:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      44:	40a00533          	neg	a0,a0
      48:	60e2                	ld	ra,24(sp)
      4a:	6442                	ld	s0,16(sp)
      4c:	64a2                	ld	s1,8(sp)
      4e:	6902                	ld	s2,0(sp)
      50:	6105                	add	sp,sp,32
      52:	8082                	ret

0000000000000054 <panic>:
  exit(0);
}

void
panic(char *s)
{
      54:	1141                	add	sp,sp,-16
      56:	e406                	sd	ra,8(sp)
      58:	e022                	sd	s0,0(sp)
      5a:	0800                	add	s0,sp,16
      5c:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      5e:	00001597          	auipc	a1,0x1
      62:	28a58593          	add	a1,a1,650 # 12e8 <malloc+0xee>
      66:	4509                	li	a0,2
      68:	00001097          	auipc	ra,0x1
      6c:	0ac080e7          	jalr	172(ra) # 1114 <fprintf>
  exit(1);
      70:	4505                	li	a0,1
      72:	00001097          	auipc	ra,0x1
      76:	d68080e7          	jalr	-664(ra) # dda <exit>

000000000000007a <fork1>:
}

int
fork1(void)
{
      7a:	1141                	add	sp,sp,-16
      7c:	e406                	sd	ra,8(sp)
      7e:	e022                	sd	s0,0(sp)
      80:	0800                	add	s0,sp,16
  int pid;

  pid = fork();
      82:	00001097          	auipc	ra,0x1
      86:	d50080e7          	jalr	-688(ra) # dd2 <fork>
  if(pid == -1)
      8a:	57fd                	li	a5,-1
      8c:	00f50663          	beq	a0,a5,98 <fork1+0x1e>
    panic("fork");
  return pid;
}
      90:	60a2                	ld	ra,8(sp)
      92:	6402                	ld	s0,0(sp)
      94:	0141                	add	sp,sp,16
      96:	8082                	ret
    panic("fork");
      98:	00001517          	auipc	a0,0x1
      9c:	25850513          	add	a0,a0,600 # 12f0 <malloc+0xf6>
      a0:	00000097          	auipc	ra,0x0
      a4:	fb4080e7          	jalr	-76(ra) # 54 <panic>

00000000000000a8 <runcmd>:
{
      a8:	7179                	add	sp,sp,-48
      aa:	f406                	sd	ra,40(sp)
      ac:	f022                	sd	s0,32(sp)
      ae:	ec26                	sd	s1,24(sp)
      b0:	1800                	add	s0,sp,48
  if(cmd == 0)
      b2:	c10d                	beqz	a0,d4 <runcmd+0x2c>
      b4:	84aa                	mv	s1,a0
  switch(cmd->type){
      b6:	4118                	lw	a4,0(a0)
      b8:	4795                	li	a5,5
      ba:	02e7e263          	bltu	a5,a4,de <runcmd+0x36>
      be:	00056783          	lwu	a5,0(a0)
      c2:	078a                	sll	a5,a5,0x2
      c4:	00001717          	auipc	a4,0x1
      c8:	32c70713          	add	a4,a4,812 # 13f0 <malloc+0x1f6>
      cc:	97ba                	add	a5,a5,a4
      ce:	439c                	lw	a5,0(a5)
      d0:	97ba                	add	a5,a5,a4
      d2:	8782                	jr	a5
    exit(1);
      d4:	4505                	li	a0,1
      d6:	00001097          	auipc	ra,0x1
      da:	d04080e7          	jalr	-764(ra) # dda <exit>
    panic("runcmd");
      de:	00001517          	auipc	a0,0x1
      e2:	21a50513          	add	a0,a0,538 # 12f8 <malloc+0xfe>
      e6:	00000097          	auipc	ra,0x0
      ea:	f6e080e7          	jalr	-146(ra) # 54 <panic>
    if(ecmd->argv[0] == 0)
      ee:	6508                	ld	a0,8(a0)
      f0:	c515                	beqz	a0,11c <runcmd+0x74>
    exec(ecmd->argv[0], ecmd->argv);
      f2:	00848593          	add	a1,s1,8
      f6:	00001097          	auipc	ra,0x1
      fa:	d1c080e7          	jalr	-740(ra) # e12 <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
      fe:	6490                	ld	a2,8(s1)
     100:	00001597          	auipc	a1,0x1
     104:	20058593          	add	a1,a1,512 # 1300 <malloc+0x106>
     108:	4509                	li	a0,2
     10a:	00001097          	auipc	ra,0x1
     10e:	00a080e7          	jalr	10(ra) # 1114 <fprintf>
  exit(0);
     112:	4501                	li	a0,0
     114:	00001097          	auipc	ra,0x1
     118:	cc6080e7          	jalr	-826(ra) # dda <exit>
      exit(1);
     11c:	4505                	li	a0,1
     11e:	00001097          	auipc	ra,0x1
     122:	cbc080e7          	jalr	-836(ra) # dda <exit>
    close(rcmd->fd);
     126:	5148                	lw	a0,36(a0)
     128:	00001097          	auipc	ra,0x1
     12c:	cda080e7          	jalr	-806(ra) # e02 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     130:	508c                	lw	a1,32(s1)
     132:	6888                	ld	a0,16(s1)
     134:	00001097          	auipc	ra,0x1
     138:	ce6080e7          	jalr	-794(ra) # e1a <open>
     13c:	00054763          	bltz	a0,14a <runcmd+0xa2>
    runcmd(rcmd->cmd);
     140:	6488                	ld	a0,8(s1)
     142:	00000097          	auipc	ra,0x0
     146:	f66080e7          	jalr	-154(ra) # a8 <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     14a:	6890                	ld	a2,16(s1)
     14c:	00001597          	auipc	a1,0x1
     150:	1c458593          	add	a1,a1,452 # 1310 <malloc+0x116>
     154:	4509                	li	a0,2
     156:	00001097          	auipc	ra,0x1
     15a:	fbe080e7          	jalr	-66(ra) # 1114 <fprintf>
      exit(1);
     15e:	4505                	li	a0,1
     160:	00001097          	auipc	ra,0x1
     164:	c7a080e7          	jalr	-902(ra) # dda <exit>
    if(fork1() == 0)
     168:	00000097          	auipc	ra,0x0
     16c:	f12080e7          	jalr	-238(ra) # 7a <fork1>
     170:	e511                	bnez	a0,17c <runcmd+0xd4>
      runcmd(lcmd->left);
     172:	6488                	ld	a0,8(s1)
     174:	00000097          	auipc	ra,0x0
     178:	f34080e7          	jalr	-204(ra) # a8 <runcmd>
    wait(0);
     17c:	4501                	li	a0,0
     17e:	00001097          	auipc	ra,0x1
     182:	c64080e7          	jalr	-924(ra) # de2 <wait>
    runcmd(lcmd->right);
     186:	6888                	ld	a0,16(s1)
     188:	00000097          	auipc	ra,0x0
     18c:	f20080e7          	jalr	-224(ra) # a8 <runcmd>
    if(pipe(p) < 0)
     190:	fd840513          	add	a0,s0,-40
     194:	00001097          	auipc	ra,0x1
     198:	c56080e7          	jalr	-938(ra) # dea <pipe>
     19c:	04054363          	bltz	a0,1e2 <runcmd+0x13a>
    if(fork1() == 0){
     1a0:	00000097          	auipc	ra,0x0
     1a4:	eda080e7          	jalr	-294(ra) # 7a <fork1>
     1a8:	e529                	bnez	a0,1f2 <runcmd+0x14a>
      close(1);
     1aa:	4505                	li	a0,1
     1ac:	00001097          	auipc	ra,0x1
     1b0:	c56080e7          	jalr	-938(ra) # e02 <close>
      dup(p[1]);
     1b4:	fdc42503          	lw	a0,-36(s0)
     1b8:	00001097          	auipc	ra,0x1
     1bc:	c9a080e7          	jalr	-870(ra) # e52 <dup>
      close(p[0]);
     1c0:	fd842503          	lw	a0,-40(s0)
     1c4:	00001097          	auipc	ra,0x1
     1c8:	c3e080e7          	jalr	-962(ra) # e02 <close>
      close(p[1]);
     1cc:	fdc42503          	lw	a0,-36(s0)
     1d0:	00001097          	auipc	ra,0x1
     1d4:	c32080e7          	jalr	-974(ra) # e02 <close>
      runcmd(pcmd->left);
     1d8:	6488                	ld	a0,8(s1)
     1da:	00000097          	auipc	ra,0x0
     1de:	ece080e7          	jalr	-306(ra) # a8 <runcmd>
      panic("pipe");
     1e2:	00001517          	auipc	a0,0x1
     1e6:	13e50513          	add	a0,a0,318 # 1320 <malloc+0x126>
     1ea:	00000097          	auipc	ra,0x0
     1ee:	e6a080e7          	jalr	-406(ra) # 54 <panic>
    if(fork1() == 0){
     1f2:	00000097          	auipc	ra,0x0
     1f6:	e88080e7          	jalr	-376(ra) # 7a <fork1>
     1fa:	ed05                	bnez	a0,232 <runcmd+0x18a>
      close(0);
     1fc:	00001097          	auipc	ra,0x1
     200:	c06080e7          	jalr	-1018(ra) # e02 <close>
      dup(p[0]);
     204:	fd842503          	lw	a0,-40(s0)
     208:	00001097          	auipc	ra,0x1
     20c:	c4a080e7          	jalr	-950(ra) # e52 <dup>
      close(p[0]);
     210:	fd842503          	lw	a0,-40(s0)
     214:	00001097          	auipc	ra,0x1
     218:	bee080e7          	jalr	-1042(ra) # e02 <close>
      close(p[1]);
     21c:	fdc42503          	lw	a0,-36(s0)
     220:	00001097          	auipc	ra,0x1
     224:	be2080e7          	jalr	-1054(ra) # e02 <close>
      runcmd(pcmd->right);
     228:	6888                	ld	a0,16(s1)
     22a:	00000097          	auipc	ra,0x0
     22e:	e7e080e7          	jalr	-386(ra) # a8 <runcmd>
    close(p[0]);
     232:	fd842503          	lw	a0,-40(s0)
     236:	00001097          	auipc	ra,0x1
     23a:	bcc080e7          	jalr	-1076(ra) # e02 <close>
    close(p[1]);
     23e:	fdc42503          	lw	a0,-36(s0)
     242:	00001097          	auipc	ra,0x1
     246:	bc0080e7          	jalr	-1088(ra) # e02 <close>
    wait(0);
     24a:	4501                	li	a0,0
     24c:	00001097          	auipc	ra,0x1
     250:	b96080e7          	jalr	-1130(ra) # de2 <wait>
    wait(0);
     254:	4501                	li	a0,0
     256:	00001097          	auipc	ra,0x1
     25a:	b8c080e7          	jalr	-1140(ra) # de2 <wait>
    break;
     25e:	bd55                	j	112 <runcmd+0x6a>
    if(fork1() == 0)
     260:	00000097          	auipc	ra,0x0
     264:	e1a080e7          	jalr	-486(ra) # 7a <fork1>
     268:	ea0515e3          	bnez	a0,112 <runcmd+0x6a>
      runcmd(bcmd->cmd);
     26c:	6488                	ld	a0,8(s1)
     26e:	00000097          	auipc	ra,0x0
     272:	e3a080e7          	jalr	-454(ra) # a8 <runcmd>

0000000000000276 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     276:	1101                	add	sp,sp,-32
     278:	ec06                	sd	ra,24(sp)
     27a:	e822                	sd	s0,16(sp)
     27c:	e426                	sd	s1,8(sp)
     27e:	1000                	add	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     280:	0a800513          	li	a0,168
     284:	00001097          	auipc	ra,0x1
     288:	f76080e7          	jalr	-138(ra) # 11fa <malloc>
     28c:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     28e:	0a800613          	li	a2,168
     292:	4581                	li	a1,0
     294:	00001097          	auipc	ra,0x1
     298:	94c080e7          	jalr	-1716(ra) # be0 <memset>
  cmd->type = EXEC;
     29c:	4785                	li	a5,1
     29e:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     2a0:	8526                	mv	a0,s1
     2a2:	60e2                	ld	ra,24(sp)
     2a4:	6442                	ld	s0,16(sp)
     2a6:	64a2                	ld	s1,8(sp)
     2a8:	6105                	add	sp,sp,32
     2aa:	8082                	ret

00000000000002ac <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     2ac:	7139                	add	sp,sp,-64
     2ae:	fc06                	sd	ra,56(sp)
     2b0:	f822                	sd	s0,48(sp)
     2b2:	f426                	sd	s1,40(sp)
     2b4:	f04a                	sd	s2,32(sp)
     2b6:	ec4e                	sd	s3,24(sp)
     2b8:	e852                	sd	s4,16(sp)
     2ba:	e456                	sd	s5,8(sp)
     2bc:	e05a                	sd	s6,0(sp)
     2be:	0080                	add	s0,sp,64
     2c0:	8b2a                	mv	s6,a0
     2c2:	8aae                	mv	s5,a1
     2c4:	8a32                	mv	s4,a2
     2c6:	89b6                	mv	s3,a3
     2c8:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2ca:	02800513          	li	a0,40
     2ce:	00001097          	auipc	ra,0x1
     2d2:	f2c080e7          	jalr	-212(ra) # 11fa <malloc>
     2d6:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2d8:	02800613          	li	a2,40
     2dc:	4581                	li	a1,0
     2de:	00001097          	auipc	ra,0x1
     2e2:	902080e7          	jalr	-1790(ra) # be0 <memset>
  cmd->type = REDIR;
     2e6:	4789                	li	a5,2
     2e8:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     2ea:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     2ee:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     2f2:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     2f6:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     2fa:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     2fe:	8526                	mv	a0,s1
     300:	70e2                	ld	ra,56(sp)
     302:	7442                	ld	s0,48(sp)
     304:	74a2                	ld	s1,40(sp)
     306:	7902                	ld	s2,32(sp)
     308:	69e2                	ld	s3,24(sp)
     30a:	6a42                	ld	s4,16(sp)
     30c:	6aa2                	ld	s5,8(sp)
     30e:	6b02                	ld	s6,0(sp)
     310:	6121                	add	sp,sp,64
     312:	8082                	ret

0000000000000314 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     314:	7179                	add	sp,sp,-48
     316:	f406                	sd	ra,40(sp)
     318:	f022                	sd	s0,32(sp)
     31a:	ec26                	sd	s1,24(sp)
     31c:	e84a                	sd	s2,16(sp)
     31e:	e44e                	sd	s3,8(sp)
     320:	1800                	add	s0,sp,48
     322:	89aa                	mv	s3,a0
     324:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     326:	4561                	li	a0,24
     328:	00001097          	auipc	ra,0x1
     32c:	ed2080e7          	jalr	-302(ra) # 11fa <malloc>
     330:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     332:	4661                	li	a2,24
     334:	4581                	li	a1,0
     336:	00001097          	auipc	ra,0x1
     33a:	8aa080e7          	jalr	-1878(ra) # be0 <memset>
  cmd->type = PIPE;
     33e:	478d                	li	a5,3
     340:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     342:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     346:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     34a:	8526                	mv	a0,s1
     34c:	70a2                	ld	ra,40(sp)
     34e:	7402                	ld	s0,32(sp)
     350:	64e2                	ld	s1,24(sp)
     352:	6942                	ld	s2,16(sp)
     354:	69a2                	ld	s3,8(sp)
     356:	6145                	add	sp,sp,48
     358:	8082                	ret

000000000000035a <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     35a:	7179                	add	sp,sp,-48
     35c:	f406                	sd	ra,40(sp)
     35e:	f022                	sd	s0,32(sp)
     360:	ec26                	sd	s1,24(sp)
     362:	e84a                	sd	s2,16(sp)
     364:	e44e                	sd	s3,8(sp)
     366:	1800                	add	s0,sp,48
     368:	89aa                	mv	s3,a0
     36a:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     36c:	4561                	li	a0,24
     36e:	00001097          	auipc	ra,0x1
     372:	e8c080e7          	jalr	-372(ra) # 11fa <malloc>
     376:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     378:	4661                	li	a2,24
     37a:	4581                	li	a1,0
     37c:	00001097          	auipc	ra,0x1
     380:	864080e7          	jalr	-1948(ra) # be0 <memset>
  cmd->type = LIST;
     384:	4791                	li	a5,4
     386:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     388:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     38c:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     390:	8526                	mv	a0,s1
     392:	70a2                	ld	ra,40(sp)
     394:	7402                	ld	s0,32(sp)
     396:	64e2                	ld	s1,24(sp)
     398:	6942                	ld	s2,16(sp)
     39a:	69a2                	ld	s3,8(sp)
     39c:	6145                	add	sp,sp,48
     39e:	8082                	ret

00000000000003a0 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     3a0:	1101                	add	sp,sp,-32
     3a2:	ec06                	sd	ra,24(sp)
     3a4:	e822                	sd	s0,16(sp)
     3a6:	e426                	sd	s1,8(sp)
     3a8:	e04a                	sd	s2,0(sp)
     3aa:	1000                	add	s0,sp,32
     3ac:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3ae:	4541                	li	a0,16
     3b0:	00001097          	auipc	ra,0x1
     3b4:	e4a080e7          	jalr	-438(ra) # 11fa <malloc>
     3b8:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     3ba:	4641                	li	a2,16
     3bc:	4581                	li	a1,0
     3be:	00001097          	auipc	ra,0x1
     3c2:	822080e7          	jalr	-2014(ra) # be0 <memset>
  cmd->type = BACK;
     3c6:	4795                	li	a5,5
     3c8:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     3ca:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     3ce:	8526                	mv	a0,s1
     3d0:	60e2                	ld	ra,24(sp)
     3d2:	6442                	ld	s0,16(sp)
     3d4:	64a2                	ld	s1,8(sp)
     3d6:	6902                	ld	s2,0(sp)
     3d8:	6105                	add	sp,sp,32
     3da:	8082                	ret

00000000000003dc <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     3dc:	7139                	add	sp,sp,-64
     3de:	fc06                	sd	ra,56(sp)
     3e0:	f822                	sd	s0,48(sp)
     3e2:	f426                	sd	s1,40(sp)
     3e4:	f04a                	sd	s2,32(sp)
     3e6:	ec4e                	sd	s3,24(sp)
     3e8:	e852                	sd	s4,16(sp)
     3ea:	e456                	sd	s5,8(sp)
     3ec:	e05a                	sd	s6,0(sp)
     3ee:	0080                	add	s0,sp,64
     3f0:	8a2a                	mv	s4,a0
     3f2:	892e                	mv	s2,a1
     3f4:	8ab2                	mv	s5,a2
     3f6:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     3f8:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     3fa:	00001997          	auipc	s3,0x1
     3fe:	0a698993          	add	s3,s3,166 # 14a0 <whitespace>
     402:	00b4fe63          	bgeu	s1,a1,41e <gettoken+0x42>
     406:	0004c583          	lbu	a1,0(s1)
     40a:	854e                	mv	a0,s3
     40c:	00000097          	auipc	ra,0x0
     410:	7f6080e7          	jalr	2038(ra) # c02 <strchr>
     414:	c509                	beqz	a0,41e <gettoken+0x42>
    s++;
     416:	0485                	add	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     418:	fe9917e3          	bne	s2,s1,406 <gettoken+0x2a>
    s++;
     41c:	84ca                	mv	s1,s2
  if(q)
     41e:	000a8463          	beqz	s5,426 <gettoken+0x4a>
    *q = s;
     422:	009ab023          	sd	s1,0(s5)
  ret = *s;
     426:	0004c783          	lbu	a5,0(s1)
     42a:	00078a9b          	sext.w	s5,a5
  switch(*s){
     42e:	03c00713          	li	a4,60
     432:	06f76663          	bltu	a4,a5,49e <gettoken+0xc2>
     436:	03a00713          	li	a4,58
     43a:	00f76e63          	bltu	a4,a5,456 <gettoken+0x7a>
     43e:	cf89                	beqz	a5,458 <gettoken+0x7c>
     440:	02600713          	li	a4,38
     444:	00e78963          	beq	a5,a4,456 <gettoken+0x7a>
     448:	fd87879b          	addw	a5,a5,-40
     44c:	0ff7f793          	zext.b	a5,a5
     450:	4705                	li	a4,1
     452:	06f76d63          	bltu	a4,a5,4cc <gettoken+0xf0>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     456:	0485                	add	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     458:	000b0463          	beqz	s6,460 <gettoken+0x84>
    *eq = s;
     45c:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     460:	00001997          	auipc	s3,0x1
     464:	04098993          	add	s3,s3,64 # 14a0 <whitespace>
     468:	0124fe63          	bgeu	s1,s2,484 <gettoken+0xa8>
     46c:	0004c583          	lbu	a1,0(s1)
     470:	854e                	mv	a0,s3
     472:	00000097          	auipc	ra,0x0
     476:	790080e7          	jalr	1936(ra) # c02 <strchr>
     47a:	c509                	beqz	a0,484 <gettoken+0xa8>
    s++;
     47c:	0485                	add	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     47e:	fe9917e3          	bne	s2,s1,46c <gettoken+0x90>
    s++;
     482:	84ca                	mv	s1,s2
  *ps = s;
     484:	009a3023          	sd	s1,0(s4)
  return ret;
}
     488:	8556                	mv	a0,s5
     48a:	70e2                	ld	ra,56(sp)
     48c:	7442                	ld	s0,48(sp)
     48e:	74a2                	ld	s1,40(sp)
     490:	7902                	ld	s2,32(sp)
     492:	69e2                	ld	s3,24(sp)
     494:	6a42                	ld	s4,16(sp)
     496:	6aa2                	ld	s5,8(sp)
     498:	6b02                	ld	s6,0(sp)
     49a:	6121                	add	sp,sp,64
     49c:	8082                	ret
  switch(*s){
     49e:	03e00713          	li	a4,62
     4a2:	02e79163          	bne	a5,a4,4c4 <gettoken+0xe8>
    s++;
     4a6:	00148693          	add	a3,s1,1
    if(*s == '>'){
     4aa:	0014c703          	lbu	a4,1(s1)
     4ae:	03e00793          	li	a5,62
      s++;
     4b2:	0489                	add	s1,s1,2
      ret = '+';
     4b4:	02b00a93          	li	s5,43
    if(*s == '>'){
     4b8:	faf700e3          	beq	a4,a5,458 <gettoken+0x7c>
    s++;
     4bc:	84b6                	mv	s1,a3
  ret = *s;
     4be:	03e00a93          	li	s5,62
     4c2:	bf59                	j	458 <gettoken+0x7c>
  switch(*s){
     4c4:	07c00713          	li	a4,124
     4c8:	f8e787e3          	beq	a5,a4,456 <gettoken+0x7a>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     4cc:	00001997          	auipc	s3,0x1
     4d0:	fd498993          	add	s3,s3,-44 # 14a0 <whitespace>
     4d4:	00001a97          	auipc	s5,0x1
     4d8:	fc4a8a93          	add	s5,s5,-60 # 1498 <symbols>
     4dc:	0524f163          	bgeu	s1,s2,51e <gettoken+0x142>
     4e0:	0004c583          	lbu	a1,0(s1)
     4e4:	854e                	mv	a0,s3
     4e6:	00000097          	auipc	ra,0x0
     4ea:	71c080e7          	jalr	1820(ra) # c02 <strchr>
     4ee:	e50d                	bnez	a0,518 <gettoken+0x13c>
     4f0:	0004c583          	lbu	a1,0(s1)
     4f4:	8556                	mv	a0,s5
     4f6:	00000097          	auipc	ra,0x0
     4fa:	70c080e7          	jalr	1804(ra) # c02 <strchr>
     4fe:	e911                	bnez	a0,512 <gettoken+0x136>
      s++;
     500:	0485                	add	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     502:	fc991fe3          	bne	s2,s1,4e0 <gettoken+0x104>
      s++;
     506:	84ca                	mv	s1,s2
    ret = 'a';
     508:	06100a93          	li	s5,97
  if(eq)
     50c:	f40b18e3          	bnez	s6,45c <gettoken+0x80>
     510:	bf95                	j	484 <gettoken+0xa8>
    ret = 'a';
     512:	06100a93          	li	s5,97
     516:	b789                	j	458 <gettoken+0x7c>
     518:	06100a93          	li	s5,97
     51c:	bf35                	j	458 <gettoken+0x7c>
     51e:	06100a93          	li	s5,97
  if(eq)
     522:	f20b1de3          	bnez	s6,45c <gettoken+0x80>
     526:	bfb9                	j	484 <gettoken+0xa8>

0000000000000528 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     528:	7139                	add	sp,sp,-64
     52a:	fc06                	sd	ra,56(sp)
     52c:	f822                	sd	s0,48(sp)
     52e:	f426                	sd	s1,40(sp)
     530:	f04a                	sd	s2,32(sp)
     532:	ec4e                	sd	s3,24(sp)
     534:	e852                	sd	s4,16(sp)
     536:	e456                	sd	s5,8(sp)
     538:	0080                	add	s0,sp,64
     53a:	8a2a                	mv	s4,a0
     53c:	892e                	mv	s2,a1
     53e:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     540:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     542:	00001997          	auipc	s3,0x1
     546:	f5e98993          	add	s3,s3,-162 # 14a0 <whitespace>
     54a:	00b4fe63          	bgeu	s1,a1,566 <peek+0x3e>
     54e:	0004c583          	lbu	a1,0(s1)
     552:	854e                	mv	a0,s3
     554:	00000097          	auipc	ra,0x0
     558:	6ae080e7          	jalr	1710(ra) # c02 <strchr>
     55c:	c509                	beqz	a0,566 <peek+0x3e>
    s++;
     55e:	0485                	add	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     560:	fe9917e3          	bne	s2,s1,54e <peek+0x26>
    s++;
     564:	84ca                	mv	s1,s2
  *ps = s;
     566:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     56a:	0004c583          	lbu	a1,0(s1)
     56e:	4501                	li	a0,0
     570:	e991                	bnez	a1,584 <peek+0x5c>
}
     572:	70e2                	ld	ra,56(sp)
     574:	7442                	ld	s0,48(sp)
     576:	74a2                	ld	s1,40(sp)
     578:	7902                	ld	s2,32(sp)
     57a:	69e2                	ld	s3,24(sp)
     57c:	6a42                	ld	s4,16(sp)
     57e:	6aa2                	ld	s5,8(sp)
     580:	6121                	add	sp,sp,64
     582:	8082                	ret
  return *s && strchr(toks, *s);
     584:	8556                	mv	a0,s5
     586:	00000097          	auipc	ra,0x0
     58a:	67c080e7          	jalr	1660(ra) # c02 <strchr>
     58e:	00a03533          	snez	a0,a0
     592:	b7c5                	j	572 <peek+0x4a>

0000000000000594 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     594:	7159                	add	sp,sp,-112
     596:	f486                	sd	ra,104(sp)
     598:	f0a2                	sd	s0,96(sp)
     59a:	eca6                	sd	s1,88(sp)
     59c:	e8ca                	sd	s2,80(sp)
     59e:	e4ce                	sd	s3,72(sp)
     5a0:	e0d2                	sd	s4,64(sp)
     5a2:	fc56                	sd	s5,56(sp)
     5a4:	f85a                	sd	s6,48(sp)
     5a6:	f45e                	sd	s7,40(sp)
     5a8:	f062                	sd	s8,32(sp)
     5aa:	ec66                	sd	s9,24(sp)
     5ac:	1880                	add	s0,sp,112
     5ae:	8a2a                	mv	s4,a0
     5b0:	89ae                	mv	s3,a1
     5b2:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     5b4:	00001b97          	auipc	s7,0x1
     5b8:	d94b8b93          	add	s7,s7,-620 # 1348 <malloc+0x14e>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     5bc:	06100c13          	li	s8,97
      panic("missing file for redirection");
    switch(tok){
     5c0:	03c00c93          	li	s9,60
  while(peek(ps, es, "<>")){
     5c4:	a02d                	j	5ee <parseredirs+0x5a>
      panic("missing file for redirection");
     5c6:	00001517          	auipc	a0,0x1
     5ca:	d6250513          	add	a0,a0,-670 # 1328 <malloc+0x12e>
     5ce:	00000097          	auipc	ra,0x0
     5d2:	a86080e7          	jalr	-1402(ra) # 54 <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     5d6:	4701                	li	a4,0
     5d8:	4681                	li	a3,0
     5da:	f9043603          	ld	a2,-112(s0)
     5de:	f9843583          	ld	a1,-104(s0)
     5e2:	8552                	mv	a0,s4
     5e4:	00000097          	auipc	ra,0x0
     5e8:	cc8080e7          	jalr	-824(ra) # 2ac <redircmd>
     5ec:	8a2a                	mv	s4,a0
    switch(tok){
     5ee:	03e00b13          	li	s6,62
     5f2:	02b00a93          	li	s5,43
  while(peek(ps, es, "<>")){
     5f6:	865e                	mv	a2,s7
     5f8:	85ca                	mv	a1,s2
     5fa:	854e                	mv	a0,s3
     5fc:	00000097          	auipc	ra,0x0
     600:	f2c080e7          	jalr	-212(ra) # 528 <peek>
     604:	c925                	beqz	a0,674 <parseredirs+0xe0>
    tok = gettoken(ps, es, 0, 0);
     606:	4681                	li	a3,0
     608:	4601                	li	a2,0
     60a:	85ca                	mv	a1,s2
     60c:	854e                	mv	a0,s3
     60e:	00000097          	auipc	ra,0x0
     612:	dce080e7          	jalr	-562(ra) # 3dc <gettoken>
     616:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     618:	f9040693          	add	a3,s0,-112
     61c:	f9840613          	add	a2,s0,-104
     620:	85ca                	mv	a1,s2
     622:	854e                	mv	a0,s3
     624:	00000097          	auipc	ra,0x0
     628:	db8080e7          	jalr	-584(ra) # 3dc <gettoken>
     62c:	f9851de3          	bne	a0,s8,5c6 <parseredirs+0x32>
    switch(tok){
     630:	fb9483e3          	beq	s1,s9,5d6 <parseredirs+0x42>
     634:	03648263          	beq	s1,s6,658 <parseredirs+0xc4>
     638:	fb549fe3          	bne	s1,s5,5f6 <parseredirs+0x62>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     63c:	4705                	li	a4,1
     63e:	20100693          	li	a3,513
     642:	f9043603          	ld	a2,-112(s0)
     646:	f9843583          	ld	a1,-104(s0)
     64a:	8552                	mv	a0,s4
     64c:	00000097          	auipc	ra,0x0
     650:	c60080e7          	jalr	-928(ra) # 2ac <redircmd>
     654:	8a2a                	mv	s4,a0
      break;
     656:	bf61                	j	5ee <parseredirs+0x5a>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     658:	4705                	li	a4,1
     65a:	60100693          	li	a3,1537
     65e:	f9043603          	ld	a2,-112(s0)
     662:	f9843583          	ld	a1,-104(s0)
     666:	8552                	mv	a0,s4
     668:	00000097          	auipc	ra,0x0
     66c:	c44080e7          	jalr	-956(ra) # 2ac <redircmd>
     670:	8a2a                	mv	s4,a0
      break;
     672:	bfb5                	j	5ee <parseredirs+0x5a>
    }
  }
  return cmd;
}
     674:	8552                	mv	a0,s4
     676:	70a6                	ld	ra,104(sp)
     678:	7406                	ld	s0,96(sp)
     67a:	64e6                	ld	s1,88(sp)
     67c:	6946                	ld	s2,80(sp)
     67e:	69a6                	ld	s3,72(sp)
     680:	6a06                	ld	s4,64(sp)
     682:	7ae2                	ld	s5,56(sp)
     684:	7b42                	ld	s6,48(sp)
     686:	7ba2                	ld	s7,40(sp)
     688:	7c02                	ld	s8,32(sp)
     68a:	6ce2                	ld	s9,24(sp)
     68c:	6165                	add	sp,sp,112
     68e:	8082                	ret

0000000000000690 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     690:	7159                	add	sp,sp,-112
     692:	f486                	sd	ra,104(sp)
     694:	f0a2                	sd	s0,96(sp)
     696:	eca6                	sd	s1,88(sp)
     698:	e8ca                	sd	s2,80(sp)
     69a:	e4ce                	sd	s3,72(sp)
     69c:	e0d2                	sd	s4,64(sp)
     69e:	fc56                	sd	s5,56(sp)
     6a0:	f85a                	sd	s6,48(sp)
     6a2:	f45e                	sd	s7,40(sp)
     6a4:	f062                	sd	s8,32(sp)
     6a6:	ec66                	sd	s9,24(sp)
     6a8:	1880                	add	s0,sp,112
     6aa:	8a2a                	mv	s4,a0
     6ac:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     6ae:	00001617          	auipc	a2,0x1
     6b2:	ca260613          	add	a2,a2,-862 # 1350 <malloc+0x156>
     6b6:	00000097          	auipc	ra,0x0
     6ba:	e72080e7          	jalr	-398(ra) # 528 <peek>
     6be:	e905                	bnez	a0,6ee <parseexec+0x5e>
     6c0:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     6c2:	00000097          	auipc	ra,0x0
     6c6:	bb4080e7          	jalr	-1100(ra) # 276 <execcmd>
     6ca:	8c2a                	mv	s8,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     6cc:	8656                	mv	a2,s5
     6ce:	85d2                	mv	a1,s4
     6d0:	00000097          	auipc	ra,0x0
     6d4:	ec4080e7          	jalr	-316(ra) # 594 <parseredirs>
     6d8:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     6da:	008c0913          	add	s2,s8,8
     6de:	00001b17          	auipc	s6,0x1
     6e2:	c92b0b13          	add	s6,s6,-878 # 1370 <malloc+0x176>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
     6e6:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     6ea:	4ba9                	li	s7,10
  while(!peek(ps, es, "|)&;")){
     6ec:	a0b1                	j	738 <parseexec+0xa8>
    return parseblock(ps, es);
     6ee:	85d6                	mv	a1,s5
     6f0:	8552                	mv	a0,s4
     6f2:	00000097          	auipc	ra,0x0
     6f6:	1bc080e7          	jalr	444(ra) # 8ae <parseblock>
     6fa:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     6fc:	8526                	mv	a0,s1
     6fe:	70a6                	ld	ra,104(sp)
     700:	7406                	ld	s0,96(sp)
     702:	64e6                	ld	s1,88(sp)
     704:	6946                	ld	s2,80(sp)
     706:	69a6                	ld	s3,72(sp)
     708:	6a06                	ld	s4,64(sp)
     70a:	7ae2                	ld	s5,56(sp)
     70c:	7b42                	ld	s6,48(sp)
     70e:	7ba2                	ld	s7,40(sp)
     710:	7c02                	ld	s8,32(sp)
     712:	6ce2                	ld	s9,24(sp)
     714:	6165                	add	sp,sp,112
     716:	8082                	ret
      panic("syntax");
     718:	00001517          	auipc	a0,0x1
     71c:	c4050513          	add	a0,a0,-960 # 1358 <malloc+0x15e>
     720:	00000097          	auipc	ra,0x0
     724:	934080e7          	jalr	-1740(ra) # 54 <panic>
    ret = parseredirs(ret, ps, es);
     728:	8656                	mv	a2,s5
     72a:	85d2                	mv	a1,s4
     72c:	8526                	mv	a0,s1
     72e:	00000097          	auipc	ra,0x0
     732:	e66080e7          	jalr	-410(ra) # 594 <parseredirs>
     736:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     738:	865a                	mv	a2,s6
     73a:	85d6                	mv	a1,s5
     73c:	8552                	mv	a0,s4
     73e:	00000097          	auipc	ra,0x0
     742:	dea080e7          	jalr	-534(ra) # 528 <peek>
     746:	e131                	bnez	a0,78a <parseexec+0xfa>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     748:	f9040693          	add	a3,s0,-112
     74c:	f9840613          	add	a2,s0,-104
     750:	85d6                	mv	a1,s5
     752:	8552                	mv	a0,s4
     754:	00000097          	auipc	ra,0x0
     758:	c88080e7          	jalr	-888(ra) # 3dc <gettoken>
     75c:	c51d                	beqz	a0,78a <parseexec+0xfa>
    if(tok != 'a')
     75e:	fb951de3          	bne	a0,s9,718 <parseexec+0x88>
    cmd->argv[argc] = q;
     762:	f9843783          	ld	a5,-104(s0)
     766:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     76a:	f9043783          	ld	a5,-112(s0)
     76e:	04f93823          	sd	a5,80(s2)
    argc++;
     772:	2985                	addw	s3,s3,1
    if(argc >= MAXARGS)
     774:	0921                	add	s2,s2,8
     776:	fb7999e3          	bne	s3,s7,728 <parseexec+0x98>
      panic("too many args");
     77a:	00001517          	auipc	a0,0x1
     77e:	be650513          	add	a0,a0,-1050 # 1360 <malloc+0x166>
     782:	00000097          	auipc	ra,0x0
     786:	8d2080e7          	jalr	-1838(ra) # 54 <panic>
  cmd->argv[argc] = 0;
     78a:	098e                	sll	s3,s3,0x3
     78c:	9c4e                	add	s8,s8,s3
     78e:	000c3423          	sd	zero,8(s8)
  cmd->eargv[argc] = 0;
     792:	040c3c23          	sd	zero,88(s8)
  return ret;
     796:	b79d                	j	6fc <parseexec+0x6c>

0000000000000798 <parsepipe>:
{
     798:	7179                	add	sp,sp,-48
     79a:	f406                	sd	ra,40(sp)
     79c:	f022                	sd	s0,32(sp)
     79e:	ec26                	sd	s1,24(sp)
     7a0:	e84a                	sd	s2,16(sp)
     7a2:	e44e                	sd	s3,8(sp)
     7a4:	1800                	add	s0,sp,48
     7a6:	892a                	mv	s2,a0
     7a8:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     7aa:	00000097          	auipc	ra,0x0
     7ae:	ee6080e7          	jalr	-282(ra) # 690 <parseexec>
     7b2:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     7b4:	00001617          	auipc	a2,0x1
     7b8:	bc460613          	add	a2,a2,-1084 # 1378 <malloc+0x17e>
     7bc:	85ce                	mv	a1,s3
     7be:	854a                	mv	a0,s2
     7c0:	00000097          	auipc	ra,0x0
     7c4:	d68080e7          	jalr	-664(ra) # 528 <peek>
     7c8:	e909                	bnez	a0,7da <parsepipe+0x42>
}
     7ca:	8526                	mv	a0,s1
     7cc:	70a2                	ld	ra,40(sp)
     7ce:	7402                	ld	s0,32(sp)
     7d0:	64e2                	ld	s1,24(sp)
     7d2:	6942                	ld	s2,16(sp)
     7d4:	69a2                	ld	s3,8(sp)
     7d6:	6145                	add	sp,sp,48
     7d8:	8082                	ret
    gettoken(ps, es, 0, 0);
     7da:	4681                	li	a3,0
     7dc:	4601                	li	a2,0
     7de:	85ce                	mv	a1,s3
     7e0:	854a                	mv	a0,s2
     7e2:	00000097          	auipc	ra,0x0
     7e6:	bfa080e7          	jalr	-1030(ra) # 3dc <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     7ea:	85ce                	mv	a1,s3
     7ec:	854a                	mv	a0,s2
     7ee:	00000097          	auipc	ra,0x0
     7f2:	faa080e7          	jalr	-86(ra) # 798 <parsepipe>
     7f6:	85aa                	mv	a1,a0
     7f8:	8526                	mv	a0,s1
     7fa:	00000097          	auipc	ra,0x0
     7fe:	b1a080e7          	jalr	-1254(ra) # 314 <pipecmd>
     802:	84aa                	mv	s1,a0
  return cmd;
     804:	b7d9                	j	7ca <parsepipe+0x32>

0000000000000806 <parseline>:
{
     806:	7179                	add	sp,sp,-48
     808:	f406                	sd	ra,40(sp)
     80a:	f022                	sd	s0,32(sp)
     80c:	ec26                	sd	s1,24(sp)
     80e:	e84a                	sd	s2,16(sp)
     810:	e44e                	sd	s3,8(sp)
     812:	e052                	sd	s4,0(sp)
     814:	1800                	add	s0,sp,48
     816:	892a                	mv	s2,a0
     818:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     81a:	00000097          	auipc	ra,0x0
     81e:	f7e080e7          	jalr	-130(ra) # 798 <parsepipe>
     822:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     824:	00001a17          	auipc	s4,0x1
     828:	b5ca0a13          	add	s4,s4,-1188 # 1380 <malloc+0x186>
     82c:	a839                	j	84a <parseline+0x44>
    gettoken(ps, es, 0, 0);
     82e:	4681                	li	a3,0
     830:	4601                	li	a2,0
     832:	85ce                	mv	a1,s3
     834:	854a                	mv	a0,s2
     836:	00000097          	auipc	ra,0x0
     83a:	ba6080e7          	jalr	-1114(ra) # 3dc <gettoken>
    cmd = backcmd(cmd);
     83e:	8526                	mv	a0,s1
     840:	00000097          	auipc	ra,0x0
     844:	b60080e7          	jalr	-1184(ra) # 3a0 <backcmd>
     848:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     84a:	8652                	mv	a2,s4
     84c:	85ce                	mv	a1,s3
     84e:	854a                	mv	a0,s2
     850:	00000097          	auipc	ra,0x0
     854:	cd8080e7          	jalr	-808(ra) # 528 <peek>
     858:	f979                	bnez	a0,82e <parseline+0x28>
  if(peek(ps, es, ";")){
     85a:	00001617          	auipc	a2,0x1
     85e:	b2e60613          	add	a2,a2,-1234 # 1388 <malloc+0x18e>
     862:	85ce                	mv	a1,s3
     864:	854a                	mv	a0,s2
     866:	00000097          	auipc	ra,0x0
     86a:	cc2080e7          	jalr	-830(ra) # 528 <peek>
     86e:	e911                	bnez	a0,882 <parseline+0x7c>
}
     870:	8526                	mv	a0,s1
     872:	70a2                	ld	ra,40(sp)
     874:	7402                	ld	s0,32(sp)
     876:	64e2                	ld	s1,24(sp)
     878:	6942                	ld	s2,16(sp)
     87a:	69a2                	ld	s3,8(sp)
     87c:	6a02                	ld	s4,0(sp)
     87e:	6145                	add	sp,sp,48
     880:	8082                	ret
    gettoken(ps, es, 0, 0);
     882:	4681                	li	a3,0
     884:	4601                	li	a2,0
     886:	85ce                	mv	a1,s3
     888:	854a                	mv	a0,s2
     88a:	00000097          	auipc	ra,0x0
     88e:	b52080e7          	jalr	-1198(ra) # 3dc <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     892:	85ce                	mv	a1,s3
     894:	854a                	mv	a0,s2
     896:	00000097          	auipc	ra,0x0
     89a:	f70080e7          	jalr	-144(ra) # 806 <parseline>
     89e:	85aa                	mv	a1,a0
     8a0:	8526                	mv	a0,s1
     8a2:	00000097          	auipc	ra,0x0
     8a6:	ab8080e7          	jalr	-1352(ra) # 35a <listcmd>
     8aa:	84aa                	mv	s1,a0
  return cmd;
     8ac:	b7d1                	j	870 <parseline+0x6a>

00000000000008ae <parseblock>:
{
     8ae:	7179                	add	sp,sp,-48
     8b0:	f406                	sd	ra,40(sp)
     8b2:	f022                	sd	s0,32(sp)
     8b4:	ec26                	sd	s1,24(sp)
     8b6:	e84a                	sd	s2,16(sp)
     8b8:	e44e                	sd	s3,8(sp)
     8ba:	1800                	add	s0,sp,48
     8bc:	84aa                	mv	s1,a0
     8be:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     8c0:	00001617          	auipc	a2,0x1
     8c4:	a9060613          	add	a2,a2,-1392 # 1350 <malloc+0x156>
     8c8:	00000097          	auipc	ra,0x0
     8cc:	c60080e7          	jalr	-928(ra) # 528 <peek>
     8d0:	c12d                	beqz	a0,932 <parseblock+0x84>
  gettoken(ps, es, 0, 0);
     8d2:	4681                	li	a3,0
     8d4:	4601                	li	a2,0
     8d6:	85ca                	mv	a1,s2
     8d8:	8526                	mv	a0,s1
     8da:	00000097          	auipc	ra,0x0
     8de:	b02080e7          	jalr	-1278(ra) # 3dc <gettoken>
  cmd = parseline(ps, es);
     8e2:	85ca                	mv	a1,s2
     8e4:	8526                	mv	a0,s1
     8e6:	00000097          	auipc	ra,0x0
     8ea:	f20080e7          	jalr	-224(ra) # 806 <parseline>
     8ee:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     8f0:	00001617          	auipc	a2,0x1
     8f4:	ab060613          	add	a2,a2,-1360 # 13a0 <malloc+0x1a6>
     8f8:	85ca                	mv	a1,s2
     8fa:	8526                	mv	a0,s1
     8fc:	00000097          	auipc	ra,0x0
     900:	c2c080e7          	jalr	-980(ra) # 528 <peek>
     904:	cd1d                	beqz	a0,942 <parseblock+0x94>
  gettoken(ps, es, 0, 0);
     906:	4681                	li	a3,0
     908:	4601                	li	a2,0
     90a:	85ca                	mv	a1,s2
     90c:	8526                	mv	a0,s1
     90e:	00000097          	auipc	ra,0x0
     912:	ace080e7          	jalr	-1330(ra) # 3dc <gettoken>
  cmd = parseredirs(cmd, ps, es);
     916:	864a                	mv	a2,s2
     918:	85a6                	mv	a1,s1
     91a:	854e                	mv	a0,s3
     91c:	00000097          	auipc	ra,0x0
     920:	c78080e7          	jalr	-904(ra) # 594 <parseredirs>
}
     924:	70a2                	ld	ra,40(sp)
     926:	7402                	ld	s0,32(sp)
     928:	64e2                	ld	s1,24(sp)
     92a:	6942                	ld	s2,16(sp)
     92c:	69a2                	ld	s3,8(sp)
     92e:	6145                	add	sp,sp,48
     930:	8082                	ret
    panic("parseblock");
     932:	00001517          	auipc	a0,0x1
     936:	a5e50513          	add	a0,a0,-1442 # 1390 <malloc+0x196>
     93a:	fffff097          	auipc	ra,0xfffff
     93e:	71a080e7          	jalr	1818(ra) # 54 <panic>
    panic("syntax - missing )");
     942:	00001517          	auipc	a0,0x1
     946:	a6650513          	add	a0,a0,-1434 # 13a8 <malloc+0x1ae>
     94a:	fffff097          	auipc	ra,0xfffff
     94e:	70a080e7          	jalr	1802(ra) # 54 <panic>

0000000000000952 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     952:	1101                	add	sp,sp,-32
     954:	ec06                	sd	ra,24(sp)
     956:	e822                	sd	s0,16(sp)
     958:	e426                	sd	s1,8(sp)
     95a:	1000                	add	s0,sp,32
     95c:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     95e:	c521                	beqz	a0,9a6 <nulterminate+0x54>
    return 0;

  switch(cmd->type){
     960:	4118                	lw	a4,0(a0)
     962:	4795                	li	a5,5
     964:	04e7e163          	bltu	a5,a4,9a6 <nulterminate+0x54>
     968:	00056783          	lwu	a5,0(a0)
     96c:	078a                	sll	a5,a5,0x2
     96e:	00001717          	auipc	a4,0x1
     972:	a9a70713          	add	a4,a4,-1382 # 1408 <malloc+0x20e>
     976:	97ba                	add	a5,a5,a4
     978:	439c                	lw	a5,0(a5)
     97a:	97ba                	add	a5,a5,a4
     97c:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     97e:	651c                	ld	a5,8(a0)
     980:	c39d                	beqz	a5,9a6 <nulterminate+0x54>
     982:	01050793          	add	a5,a0,16
      *ecmd->eargv[i] = 0;
     986:	67b8                	ld	a4,72(a5)
     988:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     98c:	07a1                	add	a5,a5,8
     98e:	ff87b703          	ld	a4,-8(a5)
     992:	fb75                	bnez	a4,986 <nulterminate+0x34>
     994:	a809                	j	9a6 <nulterminate+0x54>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     996:	6508                	ld	a0,8(a0)
     998:	00000097          	auipc	ra,0x0
     99c:	fba080e7          	jalr	-70(ra) # 952 <nulterminate>
    *rcmd->efile = 0;
     9a0:	6c9c                	ld	a5,24(s1)
     9a2:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     9a6:	8526                	mv	a0,s1
     9a8:	60e2                	ld	ra,24(sp)
     9aa:	6442                	ld	s0,16(sp)
     9ac:	64a2                	ld	s1,8(sp)
     9ae:	6105                	add	sp,sp,32
     9b0:	8082                	ret
    nulterminate(pcmd->left);
     9b2:	6508                	ld	a0,8(a0)
     9b4:	00000097          	auipc	ra,0x0
     9b8:	f9e080e7          	jalr	-98(ra) # 952 <nulterminate>
    nulterminate(pcmd->right);
     9bc:	6888                	ld	a0,16(s1)
     9be:	00000097          	auipc	ra,0x0
     9c2:	f94080e7          	jalr	-108(ra) # 952 <nulterminate>
    break;
     9c6:	b7c5                	j	9a6 <nulterminate+0x54>
    nulterminate(lcmd->left);
     9c8:	6508                	ld	a0,8(a0)
     9ca:	00000097          	auipc	ra,0x0
     9ce:	f88080e7          	jalr	-120(ra) # 952 <nulterminate>
    nulterminate(lcmd->right);
     9d2:	6888                	ld	a0,16(s1)
     9d4:	00000097          	auipc	ra,0x0
     9d8:	f7e080e7          	jalr	-130(ra) # 952 <nulterminate>
    break;
     9dc:	b7e9                	j	9a6 <nulterminate+0x54>
    nulterminate(bcmd->cmd);
     9de:	6508                	ld	a0,8(a0)
     9e0:	00000097          	auipc	ra,0x0
     9e4:	f72080e7          	jalr	-142(ra) # 952 <nulterminate>
    break;
     9e8:	bf7d                	j	9a6 <nulterminate+0x54>

00000000000009ea <parsecmd>:
{
     9ea:	7179                	add	sp,sp,-48
     9ec:	f406                	sd	ra,40(sp)
     9ee:	f022                	sd	s0,32(sp)
     9f0:	ec26                	sd	s1,24(sp)
     9f2:	e84a                	sd	s2,16(sp)
     9f4:	1800                	add	s0,sp,48
     9f6:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     9fa:	84aa                	mv	s1,a0
     9fc:	00000097          	auipc	ra,0x0
     a00:	1ba080e7          	jalr	442(ra) # bb6 <strlen>
     a04:	1502                	sll	a0,a0,0x20
     a06:	9101                	srl	a0,a0,0x20
     a08:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     a0a:	85a6                	mv	a1,s1
     a0c:	fd840513          	add	a0,s0,-40
     a10:	00000097          	auipc	ra,0x0
     a14:	df6080e7          	jalr	-522(ra) # 806 <parseline>
     a18:	892a                	mv	s2,a0
  peek(&s, es, "");
     a1a:	00001617          	auipc	a2,0x1
     a1e:	9a660613          	add	a2,a2,-1626 # 13c0 <malloc+0x1c6>
     a22:	85a6                	mv	a1,s1
     a24:	fd840513          	add	a0,s0,-40
     a28:	00000097          	auipc	ra,0x0
     a2c:	b00080e7          	jalr	-1280(ra) # 528 <peek>
  if(s != es){
     a30:	fd843603          	ld	a2,-40(s0)
     a34:	00961e63          	bne	a2,s1,a50 <parsecmd+0x66>
  nulterminate(cmd);
     a38:	854a                	mv	a0,s2
     a3a:	00000097          	auipc	ra,0x0
     a3e:	f18080e7          	jalr	-232(ra) # 952 <nulterminate>
}
     a42:	854a                	mv	a0,s2
     a44:	70a2                	ld	ra,40(sp)
     a46:	7402                	ld	s0,32(sp)
     a48:	64e2                	ld	s1,24(sp)
     a4a:	6942                	ld	s2,16(sp)
     a4c:	6145                	add	sp,sp,48
     a4e:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     a50:	00001597          	auipc	a1,0x1
     a54:	97858593          	add	a1,a1,-1672 # 13c8 <malloc+0x1ce>
     a58:	4509                	li	a0,2
     a5a:	00000097          	auipc	ra,0x0
     a5e:	6ba080e7          	jalr	1722(ra) # 1114 <fprintf>
    panic("syntax");
     a62:	00001517          	auipc	a0,0x1
     a66:	8f650513          	add	a0,a0,-1802 # 1358 <malloc+0x15e>
     a6a:	fffff097          	auipc	ra,0xfffff
     a6e:	5ea080e7          	jalr	1514(ra) # 54 <panic>

0000000000000a72 <main>:
{
     a72:	7179                	add	sp,sp,-48
     a74:	f406                	sd	ra,40(sp)
     a76:	f022                	sd	s0,32(sp)
     a78:	ec26                	sd	s1,24(sp)
     a7a:	e84a                	sd	s2,16(sp)
     a7c:	e44e                	sd	s3,8(sp)
     a7e:	e052                	sd	s4,0(sp)
     a80:	1800                	add	s0,sp,48
  while((fd = open("console", O_RDWR)) >= 0){
     a82:	00001497          	auipc	s1,0x1
     a86:	95648493          	add	s1,s1,-1706 # 13d8 <malloc+0x1de>
     a8a:	4589                	li	a1,2
     a8c:	8526                	mv	a0,s1
     a8e:	00000097          	auipc	ra,0x0
     a92:	38c080e7          	jalr	908(ra) # e1a <open>
     a96:	00054963          	bltz	a0,aa8 <main+0x36>
    if(fd >= 3){
     a9a:	4789                	li	a5,2
     a9c:	fea7d7e3          	bge	a5,a0,a8a <main+0x18>
      close(fd);
     aa0:	00000097          	auipc	ra,0x0
     aa4:	362080e7          	jalr	866(ra) # e02 <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     aa8:	00001497          	auipc	s1,0x1
     aac:	a0848493          	add	s1,s1,-1528 # 14b0 <buf.0>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     ab0:	06300913          	li	s2,99
     ab4:	02000993          	li	s3,32
     ab8:	a819                	j	ace <main+0x5c>
    if(fork1() == 0)
     aba:	fffff097          	auipc	ra,0xfffff
     abe:	5c0080e7          	jalr	1472(ra) # 7a <fork1>
     ac2:	c549                	beqz	a0,b4c <main+0xda>
    wait(0);
     ac4:	4501                	li	a0,0
     ac6:	00000097          	auipc	ra,0x0
     aca:	31c080e7          	jalr	796(ra) # de2 <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     ace:	06400593          	li	a1,100
     ad2:	8526                	mv	a0,s1
     ad4:	fffff097          	auipc	ra,0xfffff
     ad8:	52c080e7          	jalr	1324(ra) # 0 <getcmd>
     adc:	08054463          	bltz	a0,b64 <main+0xf2>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     ae0:	0004c783          	lbu	a5,0(s1)
     ae4:	fd279be3          	bne	a5,s2,aba <main+0x48>
     ae8:	0014c703          	lbu	a4,1(s1)
     aec:	06400793          	li	a5,100
     af0:	fcf715e3          	bne	a4,a5,aba <main+0x48>
     af4:	0024c783          	lbu	a5,2(s1)
     af8:	fd3791e3          	bne	a5,s3,aba <main+0x48>
      buf[strlen(buf)-1] = 0;  // chop \n
     afc:	00001a17          	auipc	s4,0x1
     b00:	9b4a0a13          	add	s4,s4,-1612 # 14b0 <buf.0>
     b04:	8552                	mv	a0,s4
     b06:	00000097          	auipc	ra,0x0
     b0a:	0b0080e7          	jalr	176(ra) # bb6 <strlen>
     b0e:	fff5079b          	addw	a5,a0,-1
     b12:	1782                	sll	a5,a5,0x20
     b14:	9381                	srl	a5,a5,0x20
     b16:	9a3e                	add	s4,s4,a5
     b18:	000a0023          	sb	zero,0(s4)
      if(chdir(buf+3) < 0)
     b1c:	00001517          	auipc	a0,0x1
     b20:	99750513          	add	a0,a0,-1641 # 14b3 <buf.0+0x3>
     b24:	00000097          	auipc	ra,0x0
     b28:	326080e7          	jalr	806(ra) # e4a <chdir>
     b2c:	fa0551e3          	bgez	a0,ace <main+0x5c>
        fprintf(2, "cannot cd %s\n", buf+3);
     b30:	00001617          	auipc	a2,0x1
     b34:	98360613          	add	a2,a2,-1661 # 14b3 <buf.0+0x3>
     b38:	00001597          	auipc	a1,0x1
     b3c:	8a858593          	add	a1,a1,-1880 # 13e0 <malloc+0x1e6>
     b40:	4509                	li	a0,2
     b42:	00000097          	auipc	ra,0x0
     b46:	5d2080e7          	jalr	1490(ra) # 1114 <fprintf>
     b4a:	b751                	j	ace <main+0x5c>
      runcmd(parsecmd(buf));
     b4c:	00001517          	auipc	a0,0x1
     b50:	96450513          	add	a0,a0,-1692 # 14b0 <buf.0>
     b54:	00000097          	auipc	ra,0x0
     b58:	e96080e7          	jalr	-362(ra) # 9ea <parsecmd>
     b5c:	fffff097          	auipc	ra,0xfffff
     b60:	54c080e7          	jalr	1356(ra) # a8 <runcmd>
  exit(0);
     b64:	4501                	li	a0,0
     b66:	00000097          	auipc	ra,0x0
     b6a:	274080e7          	jalr	628(ra) # dda <exit>

0000000000000b6e <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
     b6e:	1141                	add	sp,sp,-16
     b70:	e422                	sd	s0,8(sp)
     b72:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     b74:	87aa                	mv	a5,a0
     b76:	0585                	add	a1,a1,1
     b78:	0785                	add	a5,a5,1
     b7a:	fff5c703          	lbu	a4,-1(a1)
     b7e:	fee78fa3          	sb	a4,-1(a5)
     b82:	fb75                	bnez	a4,b76 <strcpy+0x8>
    ;
  return os;
}
     b84:	6422                	ld	s0,8(sp)
     b86:	0141                	add	sp,sp,16
     b88:	8082                	ret

0000000000000b8a <strcmp>:

int
strcmp(const char *p, const char *q)
{
     b8a:	1141                	add	sp,sp,-16
     b8c:	e422                	sd	s0,8(sp)
     b8e:	0800                	add	s0,sp,16
  while(*p && *p == *q)
     b90:	00054783          	lbu	a5,0(a0)
     b94:	cb91                	beqz	a5,ba8 <strcmp+0x1e>
     b96:	0005c703          	lbu	a4,0(a1)
     b9a:	00f71763          	bne	a4,a5,ba8 <strcmp+0x1e>
    p++, q++;
     b9e:	0505                	add	a0,a0,1
     ba0:	0585                	add	a1,a1,1
  while(*p && *p == *q)
     ba2:	00054783          	lbu	a5,0(a0)
     ba6:	fbe5                	bnez	a5,b96 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     ba8:	0005c503          	lbu	a0,0(a1)
}
     bac:	40a7853b          	subw	a0,a5,a0
     bb0:	6422                	ld	s0,8(sp)
     bb2:	0141                	add	sp,sp,16
     bb4:	8082                	ret

0000000000000bb6 <strlen>:

unsigned int
strlen(const char *s)
{
     bb6:	1141                	add	sp,sp,-16
     bb8:	e422                	sd	s0,8(sp)
     bba:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     bbc:	00054783          	lbu	a5,0(a0)
     bc0:	cf91                	beqz	a5,bdc <strlen+0x26>
     bc2:	0505                	add	a0,a0,1
     bc4:	87aa                	mv	a5,a0
     bc6:	86be                	mv	a3,a5
     bc8:	0785                	add	a5,a5,1
     bca:	fff7c703          	lbu	a4,-1(a5)
     bce:	ff65                	bnez	a4,bc6 <strlen+0x10>
     bd0:	40a6853b          	subw	a0,a3,a0
     bd4:	2505                	addw	a0,a0,1
    ;
  return n;
}
     bd6:	6422                	ld	s0,8(sp)
     bd8:	0141                	add	sp,sp,16
     bda:	8082                	ret
  for(n = 0; s[n]; n++)
     bdc:	4501                	li	a0,0
     bde:	bfe5                	j	bd6 <strlen+0x20>

0000000000000be0 <memset>:

void*
memset(void *dst, int c, unsigned int n)
{
     be0:	1141                	add	sp,sp,-16
     be2:	e422                	sd	s0,8(sp)
     be4:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     be6:	ca19                	beqz	a2,bfc <memset+0x1c>
     be8:	87aa                	mv	a5,a0
     bea:	1602                	sll	a2,a2,0x20
     bec:	9201                	srl	a2,a2,0x20
     bee:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     bf2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     bf6:	0785                	add	a5,a5,1
     bf8:	fee79de3          	bne	a5,a4,bf2 <memset+0x12>
  }
  return dst;
}
     bfc:	6422                	ld	s0,8(sp)
     bfe:	0141                	add	sp,sp,16
     c00:	8082                	ret

0000000000000c02 <strchr>:

char*
strchr(const char *s, char c)
{
     c02:	1141                	add	sp,sp,-16
     c04:	e422                	sd	s0,8(sp)
     c06:	0800                	add	s0,sp,16
  for(; *s; s++)
     c08:	00054783          	lbu	a5,0(a0)
     c0c:	cb99                	beqz	a5,c22 <strchr+0x20>
    if(*s == c)
     c0e:	00f58763          	beq	a1,a5,c1c <strchr+0x1a>
  for(; *s; s++)
     c12:	0505                	add	a0,a0,1
     c14:	00054783          	lbu	a5,0(a0)
     c18:	fbfd                	bnez	a5,c0e <strchr+0xc>
      return (char*)s;
  return 0;
     c1a:	4501                	li	a0,0
}
     c1c:	6422                	ld	s0,8(sp)
     c1e:	0141                	add	sp,sp,16
     c20:	8082                	ret
  return 0;
     c22:	4501                	li	a0,0
     c24:	bfe5                	j	c1c <strchr+0x1a>

0000000000000c26 <gets>:

char*
gets(char *buf, int max)
{
     c26:	711d                	add	sp,sp,-96
     c28:	ec86                	sd	ra,88(sp)
     c2a:	e8a2                	sd	s0,80(sp)
     c2c:	e4a6                	sd	s1,72(sp)
     c2e:	e0ca                	sd	s2,64(sp)
     c30:	fc4e                	sd	s3,56(sp)
     c32:	f852                	sd	s4,48(sp)
     c34:	f456                	sd	s5,40(sp)
     c36:	f05a                	sd	s6,32(sp)
     c38:	ec5e                	sd	s7,24(sp)
     c3a:	1080                	add	s0,sp,96
     c3c:	8baa                	mv	s7,a0
     c3e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c40:	892a                	mv	s2,a0
     c42:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     c44:	4aa9                	li	s5,10
     c46:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     c48:	89a6                	mv	s3,s1
     c4a:	2485                	addw	s1,s1,1
     c4c:	0344d863          	bge	s1,s4,c7c <gets+0x56>
    cc = read(0, &c, 1);
     c50:	4605                	li	a2,1
     c52:	faf40593          	add	a1,s0,-81
     c56:	4501                	li	a0,0
     c58:	00000097          	auipc	ra,0x0
     c5c:	19a080e7          	jalr	410(ra) # df2 <read>
    if(cc < 1)
     c60:	00a05e63          	blez	a0,c7c <gets+0x56>
    buf[i++] = c;
     c64:	faf44783          	lbu	a5,-81(s0)
     c68:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     c6c:	01578763          	beq	a5,s5,c7a <gets+0x54>
     c70:	0905                	add	s2,s2,1
     c72:	fd679be3          	bne	a5,s6,c48 <gets+0x22>
  for(i=0; i+1 < max; ){
     c76:	89a6                	mv	s3,s1
     c78:	a011                	j	c7c <gets+0x56>
     c7a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     c7c:	99de                	add	s3,s3,s7
     c7e:	00098023          	sb	zero,0(s3)
  return buf;
}
     c82:	855e                	mv	a0,s7
     c84:	60e6                	ld	ra,88(sp)
     c86:	6446                	ld	s0,80(sp)
     c88:	64a6                	ld	s1,72(sp)
     c8a:	6906                	ld	s2,64(sp)
     c8c:	79e2                	ld	s3,56(sp)
     c8e:	7a42                	ld	s4,48(sp)
     c90:	7aa2                	ld	s5,40(sp)
     c92:	7b02                	ld	s6,32(sp)
     c94:	6be2                	ld	s7,24(sp)
     c96:	6125                	add	sp,sp,96
     c98:	8082                	ret

0000000000000c9a <stat>:

int
stat(const char *n, struct stat *st)
{
     c9a:	1101                	add	sp,sp,-32
     c9c:	ec06                	sd	ra,24(sp)
     c9e:	e822                	sd	s0,16(sp)
     ca0:	e426                	sd	s1,8(sp)
     ca2:	e04a                	sd	s2,0(sp)
     ca4:	1000                	add	s0,sp,32
     ca6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     ca8:	4581                	li	a1,0
     caa:	00000097          	auipc	ra,0x0
     cae:	170080e7          	jalr	368(ra) # e1a <open>
  if(fd < 0)
     cb2:	02054563          	bltz	a0,cdc <stat+0x42>
     cb6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     cb8:	85ca                	mv	a1,s2
     cba:	00000097          	auipc	ra,0x0
     cbe:	178080e7          	jalr	376(ra) # e32 <fstat>
     cc2:	892a                	mv	s2,a0
  close(fd);
     cc4:	8526                	mv	a0,s1
     cc6:	00000097          	auipc	ra,0x0
     cca:	13c080e7          	jalr	316(ra) # e02 <close>
  return r;
}
     cce:	854a                	mv	a0,s2
     cd0:	60e2                	ld	ra,24(sp)
     cd2:	6442                	ld	s0,16(sp)
     cd4:	64a2                	ld	s1,8(sp)
     cd6:	6902                	ld	s2,0(sp)
     cd8:	6105                	add	sp,sp,32
     cda:	8082                	ret
    return -1;
     cdc:	597d                	li	s2,-1
     cde:	bfc5                	j	cce <stat+0x34>

0000000000000ce0 <atoi>:

int
atoi(const char *s)
{
     ce0:	1141                	add	sp,sp,-16
     ce2:	e422                	sd	s0,8(sp)
     ce4:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     ce6:	00054683          	lbu	a3,0(a0)
     cea:	fd06879b          	addw	a5,a3,-48
     cee:	0ff7f793          	zext.b	a5,a5
     cf2:	4625                	li	a2,9
     cf4:	02f66863          	bltu	a2,a5,d24 <atoi+0x44>
     cf8:	872a                	mv	a4,a0
  n = 0;
     cfa:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     cfc:	0705                	add	a4,a4,1
     cfe:	0025179b          	sllw	a5,a0,0x2
     d02:	9fa9                	addw	a5,a5,a0
     d04:	0017979b          	sllw	a5,a5,0x1
     d08:	9fb5                	addw	a5,a5,a3
     d0a:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     d0e:	00074683          	lbu	a3,0(a4)
     d12:	fd06879b          	addw	a5,a3,-48
     d16:	0ff7f793          	zext.b	a5,a5
     d1a:	fef671e3          	bgeu	a2,a5,cfc <atoi+0x1c>
  return n;
}
     d1e:	6422                	ld	s0,8(sp)
     d20:	0141                	add	sp,sp,16
     d22:	8082                	ret
  n = 0;
     d24:	4501                	li	a0,0
     d26:	bfe5                	j	d1e <atoi+0x3e>

0000000000000d28 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d28:	1141                	add	sp,sp,-16
     d2a:	e422                	sd	s0,8(sp)
     d2c:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     d2e:	02b57463          	bgeu	a0,a1,d56 <memmove+0x2e>
    while(n-- > 0)
     d32:	00c05f63          	blez	a2,d50 <memmove+0x28>
     d36:	1602                	sll	a2,a2,0x20
     d38:	9201                	srl	a2,a2,0x20
     d3a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     d3e:	872a                	mv	a4,a0
      *dst++ = *src++;
     d40:	0585                	add	a1,a1,1
     d42:	0705                	add	a4,a4,1
     d44:	fff5c683          	lbu	a3,-1(a1)
     d48:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     d4c:	fee79ae3          	bne	a5,a4,d40 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     d50:	6422                	ld	s0,8(sp)
     d52:	0141                	add	sp,sp,16
     d54:	8082                	ret
    dst += n;
     d56:	00c50733          	add	a4,a0,a2
    src += n;
     d5a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     d5c:	fec05ae3          	blez	a2,d50 <memmove+0x28>
     d60:	fff6079b          	addw	a5,a2,-1
     d64:	1782                	sll	a5,a5,0x20
     d66:	9381                	srl	a5,a5,0x20
     d68:	fff7c793          	not	a5,a5
     d6c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     d6e:	15fd                	add	a1,a1,-1
     d70:	177d                	add	a4,a4,-1
     d72:	0005c683          	lbu	a3,0(a1)
     d76:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     d7a:	fee79ae3          	bne	a5,a4,d6e <memmove+0x46>
     d7e:	bfc9                	j	d50 <memmove+0x28>

0000000000000d80 <memcmp>:

int
memcmp(const void *s1, const void *s2, unsigned int n)
{
     d80:	1141                	add	sp,sp,-16
     d82:	e422                	sd	s0,8(sp)
     d84:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     d86:	ca05                	beqz	a2,db6 <memcmp+0x36>
     d88:	fff6069b          	addw	a3,a2,-1
     d8c:	1682                	sll	a3,a3,0x20
     d8e:	9281                	srl	a3,a3,0x20
     d90:	0685                	add	a3,a3,1
     d92:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     d94:	00054783          	lbu	a5,0(a0)
     d98:	0005c703          	lbu	a4,0(a1)
     d9c:	00e79863          	bne	a5,a4,dac <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     da0:	0505                	add	a0,a0,1
    p2++;
     da2:	0585                	add	a1,a1,1
  while (n-- > 0) {
     da4:	fed518e3          	bne	a0,a3,d94 <memcmp+0x14>
  }
  return 0;
     da8:	4501                	li	a0,0
     daa:	a019                	j	db0 <memcmp+0x30>
      return *p1 - *p2;
     dac:	40e7853b          	subw	a0,a5,a4
}
     db0:	6422                	ld	s0,8(sp)
     db2:	0141                	add	sp,sp,16
     db4:	8082                	ret
  return 0;
     db6:	4501                	li	a0,0
     db8:	bfe5                	j	db0 <memcmp+0x30>

0000000000000dba <memcpy>:

void *
memcpy(void *dst, const void *src, unsigned int n)
{
     dba:	1141                	add	sp,sp,-16
     dbc:	e406                	sd	ra,8(sp)
     dbe:	e022                	sd	s0,0(sp)
     dc0:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
     dc2:	00000097          	auipc	ra,0x0
     dc6:	f66080e7          	jalr	-154(ra) # d28 <memmove>
}
     dca:	60a2                	ld	ra,8(sp)
     dcc:	6402                	ld	s0,0(sp)
     dce:	0141                	add	sp,sp,16
     dd0:	8082                	ret

0000000000000dd2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     dd2:	4885                	li	a7,1
 ecall
     dd4:	00000073          	ecall
 ret
     dd8:	8082                	ret

0000000000000dda <exit>:
.global exit
exit:
 li a7, SYS_exit
     dda:	4889                	li	a7,2
 ecall
     ddc:	00000073          	ecall
 ret
     de0:	8082                	ret

0000000000000de2 <wait>:
.global wait
wait:
 li a7, SYS_wait
     de2:	488d                	li	a7,3
 ecall
     de4:	00000073          	ecall
 ret
     de8:	8082                	ret

0000000000000dea <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     dea:	4891                	li	a7,4
 ecall
     dec:	00000073          	ecall
 ret
     df0:	8082                	ret

0000000000000df2 <read>:
.global read
read:
 li a7, SYS_read
     df2:	4895                	li	a7,5
 ecall
     df4:	00000073          	ecall
 ret
     df8:	8082                	ret

0000000000000dfa <write>:
.global write
write:
 li a7, SYS_write
     dfa:	48c1                	li	a7,16
 ecall
     dfc:	00000073          	ecall
 ret
     e00:	8082                	ret

0000000000000e02 <close>:
.global close
close:
 li a7, SYS_close
     e02:	48d5                	li	a7,21
 ecall
     e04:	00000073          	ecall
 ret
     e08:	8082                	ret

0000000000000e0a <kill>:
.global kill
kill:
 li a7, SYS_kill
     e0a:	4899                	li	a7,6
 ecall
     e0c:	00000073          	ecall
 ret
     e10:	8082                	ret

0000000000000e12 <exec>:
.global exec
exec:
 li a7, SYS_exec
     e12:	489d                	li	a7,7
 ecall
     e14:	00000073          	ecall
 ret
     e18:	8082                	ret

0000000000000e1a <open>:
.global open
open:
 li a7, SYS_open
     e1a:	48bd                	li	a7,15
 ecall
     e1c:	00000073          	ecall
 ret
     e20:	8082                	ret

0000000000000e22 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     e22:	48c5                	li	a7,17
 ecall
     e24:	00000073          	ecall
 ret
     e28:	8082                	ret

0000000000000e2a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     e2a:	48c9                	li	a7,18
 ecall
     e2c:	00000073          	ecall
 ret
     e30:	8082                	ret

0000000000000e32 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     e32:	48a1                	li	a7,8
 ecall
     e34:	00000073          	ecall
 ret
     e38:	8082                	ret

0000000000000e3a <link>:
.global link
link:
 li a7, SYS_link
     e3a:	48cd                	li	a7,19
 ecall
     e3c:	00000073          	ecall
 ret
     e40:	8082                	ret

0000000000000e42 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     e42:	48d1                	li	a7,20
 ecall
     e44:	00000073          	ecall
 ret
     e48:	8082                	ret

0000000000000e4a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     e4a:	48a5                	li	a7,9
 ecall
     e4c:	00000073          	ecall
 ret
     e50:	8082                	ret

0000000000000e52 <dup>:
.global dup
dup:
 li a7, SYS_dup
     e52:	48a9                	li	a7,10
 ecall
     e54:	00000073          	ecall
 ret
     e58:	8082                	ret

0000000000000e5a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     e5a:	48ad                	li	a7,11
 ecall
     e5c:	00000073          	ecall
 ret
     e60:	8082                	ret

0000000000000e62 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     e62:	48b1                	li	a7,12
 ecall
     e64:	00000073          	ecall
 ret
     e68:	8082                	ret

0000000000000e6a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     e6a:	48b5                	li	a7,13
 ecall
     e6c:	00000073          	ecall
 ret
     e70:	8082                	ret

0000000000000e72 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     e72:	48b9                	li	a7,14
 ecall
     e74:	00000073          	ecall
 ret
     e78:	8082                	ret

0000000000000e7a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     e7a:	1101                	add	sp,sp,-32
     e7c:	ec06                	sd	ra,24(sp)
     e7e:	e822                	sd	s0,16(sp)
     e80:	1000                	add	s0,sp,32
     e82:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     e86:	4605                	li	a2,1
     e88:	fef40593          	add	a1,s0,-17
     e8c:	00000097          	auipc	ra,0x0
     e90:	f6e080e7          	jalr	-146(ra) # dfa <write>
}
     e94:	60e2                	ld	ra,24(sp)
     e96:	6442                	ld	s0,16(sp)
     e98:	6105                	add	sp,sp,32
     e9a:	8082                	ret

0000000000000e9c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     e9c:	7139                	add	sp,sp,-64
     e9e:	fc06                	sd	ra,56(sp)
     ea0:	f822                	sd	s0,48(sp)
     ea2:	f426                	sd	s1,40(sp)
     ea4:	f04a                	sd	s2,32(sp)
     ea6:	ec4e                	sd	s3,24(sp)
     ea8:	0080                	add	s0,sp,64
     eaa:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     eac:	c299                	beqz	a3,eb2 <printint+0x16>
     eae:	0805c963          	bltz	a1,f40 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     eb2:	2581                	sext.w	a1,a1
  neg = 0;
     eb4:	4881                	li	a7,0
     eb6:	fc040693          	add	a3,s0,-64
  }

  i = 0;
     eba:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     ebc:	2601                	sext.w	a2,a2
     ebe:	00000517          	auipc	a0,0x0
     ec2:	5c250513          	add	a0,a0,1474 # 1480 <digits>
     ec6:	883a                	mv	a6,a4
     ec8:	2705                	addw	a4,a4,1
     eca:	02c5f7bb          	remuw	a5,a1,a2
     ece:	1782                	sll	a5,a5,0x20
     ed0:	9381                	srl	a5,a5,0x20
     ed2:	97aa                	add	a5,a5,a0
     ed4:	0007c783          	lbu	a5,0(a5)
     ed8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     edc:	0005879b          	sext.w	a5,a1
     ee0:	02c5d5bb          	divuw	a1,a1,a2
     ee4:	0685                	add	a3,a3,1
     ee6:	fec7f0e3          	bgeu	a5,a2,ec6 <printint+0x2a>
  if(neg)
     eea:	00088c63          	beqz	a7,f02 <printint+0x66>
    buf[i++] = '-';
     eee:	fd070793          	add	a5,a4,-48
     ef2:	00878733          	add	a4,a5,s0
     ef6:	02d00793          	li	a5,45
     efa:	fef70823          	sb	a5,-16(a4)
     efe:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
     f02:	02e05863          	blez	a4,f32 <printint+0x96>
     f06:	fc040793          	add	a5,s0,-64
     f0a:	00e78933          	add	s2,a5,a4
     f0e:	fff78993          	add	s3,a5,-1
     f12:	99ba                	add	s3,s3,a4
     f14:	377d                	addw	a4,a4,-1
     f16:	1702                	sll	a4,a4,0x20
     f18:	9301                	srl	a4,a4,0x20
     f1a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     f1e:	fff94583          	lbu	a1,-1(s2)
     f22:	8526                	mv	a0,s1
     f24:	00000097          	auipc	ra,0x0
     f28:	f56080e7          	jalr	-170(ra) # e7a <putc>
  while(--i >= 0)
     f2c:	197d                	add	s2,s2,-1
     f2e:	ff3918e3          	bne	s2,s3,f1e <printint+0x82>
}
     f32:	70e2                	ld	ra,56(sp)
     f34:	7442                	ld	s0,48(sp)
     f36:	74a2                	ld	s1,40(sp)
     f38:	7902                	ld	s2,32(sp)
     f3a:	69e2                	ld	s3,24(sp)
     f3c:	6121                	add	sp,sp,64
     f3e:	8082                	ret
    x = -xx;
     f40:	40b005bb          	negw	a1,a1
    neg = 1;
     f44:	4885                	li	a7,1
    x = -xx;
     f46:	bf85                	j	eb6 <printint+0x1a>

0000000000000f48 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     f48:	715d                	add	sp,sp,-80
     f4a:	e486                	sd	ra,72(sp)
     f4c:	e0a2                	sd	s0,64(sp)
     f4e:	fc26                	sd	s1,56(sp)
     f50:	f84a                	sd	s2,48(sp)
     f52:	f44e                	sd	s3,40(sp)
     f54:	f052                	sd	s4,32(sp)
     f56:	ec56                	sd	s5,24(sp)
     f58:	e85a                	sd	s6,16(sp)
     f5a:	e45e                	sd	s7,8(sp)
     f5c:	e062                	sd	s8,0(sp)
     f5e:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     f60:	0005c903          	lbu	s2,0(a1)
     f64:	18090c63          	beqz	s2,10fc <vprintf+0x1b4>
     f68:	8aaa                	mv	s5,a0
     f6a:	8bb2                	mv	s7,a2
     f6c:	00158493          	add	s1,a1,1
  state = 0;
     f70:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     f72:	02500a13          	li	s4,37
     f76:	4b55                	li	s6,21
     f78:	a839                	j	f96 <vprintf+0x4e>
        putc(fd, c);
     f7a:	85ca                	mv	a1,s2
     f7c:	8556                	mv	a0,s5
     f7e:	00000097          	auipc	ra,0x0
     f82:	efc080e7          	jalr	-260(ra) # e7a <putc>
     f86:	a019                	j	f8c <vprintf+0x44>
    } else if(state == '%'){
     f88:	01498d63          	beq	s3,s4,fa2 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
     f8c:	0485                	add	s1,s1,1
     f8e:	fff4c903          	lbu	s2,-1(s1)
     f92:	16090563          	beqz	s2,10fc <vprintf+0x1b4>
    if(state == 0){
     f96:	fe0999e3          	bnez	s3,f88 <vprintf+0x40>
      if(c == '%'){
     f9a:	ff4910e3          	bne	s2,s4,f7a <vprintf+0x32>
        state = '%';
     f9e:	89d2                	mv	s3,s4
     fa0:	b7f5                	j	f8c <vprintf+0x44>
      if(c == 'd'){
     fa2:	13490263          	beq	s2,s4,10c6 <vprintf+0x17e>
     fa6:	f9d9079b          	addw	a5,s2,-99
     faa:	0ff7f793          	zext.b	a5,a5
     fae:	12fb6563          	bltu	s6,a5,10d8 <vprintf+0x190>
     fb2:	f9d9079b          	addw	a5,s2,-99
     fb6:	0ff7f713          	zext.b	a4,a5
     fba:	10eb6f63          	bltu	s6,a4,10d8 <vprintf+0x190>
     fbe:	00271793          	sll	a5,a4,0x2
     fc2:	00000717          	auipc	a4,0x0
     fc6:	46670713          	add	a4,a4,1126 # 1428 <malloc+0x22e>
     fca:	97ba                	add	a5,a5,a4
     fcc:	439c                	lw	a5,0(a5)
     fce:	97ba                	add	a5,a5,a4
     fd0:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     fd2:	008b8913          	add	s2,s7,8
     fd6:	4685                	li	a3,1
     fd8:	4629                	li	a2,10
     fda:	000ba583          	lw	a1,0(s7)
     fde:	8556                	mv	a0,s5
     fe0:	00000097          	auipc	ra,0x0
     fe4:	ebc080e7          	jalr	-324(ra) # e9c <printint>
     fe8:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     fea:	4981                	li	s3,0
     fec:	b745                	j	f8c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
     fee:	008b8913          	add	s2,s7,8
     ff2:	4681                	li	a3,0
     ff4:	4629                	li	a2,10
     ff6:	000ba583          	lw	a1,0(s7)
     ffa:	8556                	mv	a0,s5
     ffc:	00000097          	auipc	ra,0x0
    1000:	ea0080e7          	jalr	-352(ra) # e9c <printint>
    1004:	8bca                	mv	s7,s2
      state = 0;
    1006:	4981                	li	s3,0
    1008:	b751                	j	f8c <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
    100a:	008b8913          	add	s2,s7,8
    100e:	4681                	li	a3,0
    1010:	4641                	li	a2,16
    1012:	000ba583          	lw	a1,0(s7)
    1016:	8556                	mv	a0,s5
    1018:	00000097          	auipc	ra,0x0
    101c:	e84080e7          	jalr	-380(ra) # e9c <printint>
    1020:	8bca                	mv	s7,s2
      state = 0;
    1022:	4981                	li	s3,0
    1024:	b7a5                	j	f8c <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
    1026:	008b8c13          	add	s8,s7,8
    102a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    102e:	03000593          	li	a1,48
    1032:	8556                	mv	a0,s5
    1034:	00000097          	auipc	ra,0x0
    1038:	e46080e7          	jalr	-442(ra) # e7a <putc>
  putc(fd, 'x');
    103c:	07800593          	li	a1,120
    1040:	8556                	mv	a0,s5
    1042:	00000097          	auipc	ra,0x0
    1046:	e38080e7          	jalr	-456(ra) # e7a <putc>
    104a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    104c:	00000b97          	auipc	s7,0x0
    1050:	434b8b93          	add	s7,s7,1076 # 1480 <digits>
    1054:	03c9d793          	srl	a5,s3,0x3c
    1058:	97de                	add	a5,a5,s7
    105a:	0007c583          	lbu	a1,0(a5)
    105e:	8556                	mv	a0,s5
    1060:	00000097          	auipc	ra,0x0
    1064:	e1a080e7          	jalr	-486(ra) # e7a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1068:	0992                	sll	s3,s3,0x4
    106a:	397d                	addw	s2,s2,-1
    106c:	fe0914e3          	bnez	s2,1054 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    1070:	8be2                	mv	s7,s8
      state = 0;
    1072:	4981                	li	s3,0
    1074:	bf21                	j	f8c <vprintf+0x44>
        s = va_arg(ap, char*);
    1076:	008b8993          	add	s3,s7,8
    107a:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    107e:	02090163          	beqz	s2,10a0 <vprintf+0x158>
        while(*s != 0){
    1082:	00094583          	lbu	a1,0(s2)
    1086:	c9a5                	beqz	a1,10f6 <vprintf+0x1ae>
          putc(fd, *s);
    1088:	8556                	mv	a0,s5
    108a:	00000097          	auipc	ra,0x0
    108e:	df0080e7          	jalr	-528(ra) # e7a <putc>
          s++;
    1092:	0905                	add	s2,s2,1
        while(*s != 0){
    1094:	00094583          	lbu	a1,0(s2)
    1098:	f9e5                	bnez	a1,1088 <vprintf+0x140>
        s = va_arg(ap, char*);
    109a:	8bce                	mv	s7,s3
      state = 0;
    109c:	4981                	li	s3,0
    109e:	b5fd                	j	f8c <vprintf+0x44>
          s = "(null)";
    10a0:	00000917          	auipc	s2,0x0
    10a4:	38090913          	add	s2,s2,896 # 1420 <malloc+0x226>
        while(*s != 0){
    10a8:	02800593          	li	a1,40
    10ac:	bff1                	j	1088 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
    10ae:	008b8913          	add	s2,s7,8
    10b2:	000bc583          	lbu	a1,0(s7)
    10b6:	8556                	mv	a0,s5
    10b8:	00000097          	auipc	ra,0x0
    10bc:	dc2080e7          	jalr	-574(ra) # e7a <putc>
    10c0:	8bca                	mv	s7,s2
      state = 0;
    10c2:	4981                	li	s3,0
    10c4:	b5e1                	j	f8c <vprintf+0x44>
        putc(fd, c);
    10c6:	02500593          	li	a1,37
    10ca:	8556                	mv	a0,s5
    10cc:	00000097          	auipc	ra,0x0
    10d0:	dae080e7          	jalr	-594(ra) # e7a <putc>
      state = 0;
    10d4:	4981                	li	s3,0
    10d6:	bd5d                	j	f8c <vprintf+0x44>
        putc(fd, '%');
    10d8:	02500593          	li	a1,37
    10dc:	8556                	mv	a0,s5
    10de:	00000097          	auipc	ra,0x0
    10e2:	d9c080e7          	jalr	-612(ra) # e7a <putc>
        putc(fd, c);
    10e6:	85ca                	mv	a1,s2
    10e8:	8556                	mv	a0,s5
    10ea:	00000097          	auipc	ra,0x0
    10ee:	d90080e7          	jalr	-624(ra) # e7a <putc>
      state = 0;
    10f2:	4981                	li	s3,0
    10f4:	bd61                	j	f8c <vprintf+0x44>
        s = va_arg(ap, char*);
    10f6:	8bce                	mv	s7,s3
      state = 0;
    10f8:	4981                	li	s3,0
    10fa:	bd49                	j	f8c <vprintf+0x44>
    }
  }
}
    10fc:	60a6                	ld	ra,72(sp)
    10fe:	6406                	ld	s0,64(sp)
    1100:	74e2                	ld	s1,56(sp)
    1102:	7942                	ld	s2,48(sp)
    1104:	79a2                	ld	s3,40(sp)
    1106:	7a02                	ld	s4,32(sp)
    1108:	6ae2                	ld	s5,24(sp)
    110a:	6b42                	ld	s6,16(sp)
    110c:	6ba2                	ld	s7,8(sp)
    110e:	6c02                	ld	s8,0(sp)
    1110:	6161                	add	sp,sp,80
    1112:	8082                	ret

0000000000001114 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1114:	715d                	add	sp,sp,-80
    1116:	ec06                	sd	ra,24(sp)
    1118:	e822                	sd	s0,16(sp)
    111a:	1000                	add	s0,sp,32
    111c:	e010                	sd	a2,0(s0)
    111e:	e414                	sd	a3,8(s0)
    1120:	e818                	sd	a4,16(s0)
    1122:	ec1c                	sd	a5,24(s0)
    1124:	03043023          	sd	a6,32(s0)
    1128:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    112c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1130:	8622                	mv	a2,s0
    1132:	00000097          	auipc	ra,0x0
    1136:	e16080e7          	jalr	-490(ra) # f48 <vprintf>
}
    113a:	60e2                	ld	ra,24(sp)
    113c:	6442                	ld	s0,16(sp)
    113e:	6161                	add	sp,sp,80
    1140:	8082                	ret

0000000000001142 <printf>:

void
printf(const char *fmt, ...)
{
    1142:	711d                	add	sp,sp,-96
    1144:	ec06                	sd	ra,24(sp)
    1146:	e822                	sd	s0,16(sp)
    1148:	1000                	add	s0,sp,32
    114a:	e40c                	sd	a1,8(s0)
    114c:	e810                	sd	a2,16(s0)
    114e:	ec14                	sd	a3,24(s0)
    1150:	f018                	sd	a4,32(s0)
    1152:	f41c                	sd	a5,40(s0)
    1154:	03043823          	sd	a6,48(s0)
    1158:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    115c:	00840613          	add	a2,s0,8
    1160:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1164:	85aa                	mv	a1,a0
    1166:	4505                	li	a0,1
    1168:	00000097          	auipc	ra,0x0
    116c:	de0080e7          	jalr	-544(ra) # f48 <vprintf>
}
    1170:	60e2                	ld	ra,24(sp)
    1172:	6442                	ld	s0,16(sp)
    1174:	6125                	add	sp,sp,96
    1176:	8082                	ret

0000000000001178 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1178:	1141                	add	sp,sp,-16
    117a:	e422                	sd	s0,8(sp)
    117c:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    117e:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1182:	00000797          	auipc	a5,0x0
    1186:	3267b783          	ld	a5,806(a5) # 14a8 <freep>
    118a:	a02d                	j	11b4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    118c:	4618                	lw	a4,8(a2)
    118e:	9f2d                	addw	a4,a4,a1
    1190:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1194:	6398                	ld	a4,0(a5)
    1196:	6310                	ld	a2,0(a4)
    1198:	a83d                	j	11d6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    119a:	ff852703          	lw	a4,-8(a0)
    119e:	9f31                	addw	a4,a4,a2
    11a0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    11a2:	ff053683          	ld	a3,-16(a0)
    11a6:	a091                	j	11ea <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11a8:	6398                	ld	a4,0(a5)
    11aa:	00e7e463          	bltu	a5,a4,11b2 <free+0x3a>
    11ae:	00e6ea63          	bltu	a3,a4,11c2 <free+0x4a>
{
    11b2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11b4:	fed7fae3          	bgeu	a5,a3,11a8 <free+0x30>
    11b8:	6398                	ld	a4,0(a5)
    11ba:	00e6e463          	bltu	a3,a4,11c2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11be:	fee7eae3          	bltu	a5,a4,11b2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    11c2:	ff852583          	lw	a1,-8(a0)
    11c6:	6390                	ld	a2,0(a5)
    11c8:	02059813          	sll	a6,a1,0x20
    11cc:	01c85713          	srl	a4,a6,0x1c
    11d0:	9736                	add	a4,a4,a3
    11d2:	fae60de3          	beq	a2,a4,118c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    11d6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    11da:	4790                	lw	a2,8(a5)
    11dc:	02061593          	sll	a1,a2,0x20
    11e0:	01c5d713          	srl	a4,a1,0x1c
    11e4:	973e                	add	a4,a4,a5
    11e6:	fae68ae3          	beq	a3,a4,119a <free+0x22>
    p->s.ptr = bp->s.ptr;
    11ea:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    11ec:	00000717          	auipc	a4,0x0
    11f0:	2af73e23          	sd	a5,700(a4) # 14a8 <freep>
}
    11f4:	6422                	ld	s0,8(sp)
    11f6:	0141                	add	sp,sp,16
    11f8:	8082                	ret

00000000000011fa <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    11fa:	7139                	add	sp,sp,-64
    11fc:	fc06                	sd	ra,56(sp)
    11fe:	f822                	sd	s0,48(sp)
    1200:	f426                	sd	s1,40(sp)
    1202:	f04a                	sd	s2,32(sp)
    1204:	ec4e                	sd	s3,24(sp)
    1206:	e852                	sd	s4,16(sp)
    1208:	e456                	sd	s5,8(sp)
    120a:	e05a                	sd	s6,0(sp)
    120c:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    120e:	02051493          	sll	s1,a0,0x20
    1212:	9081                	srl	s1,s1,0x20
    1214:	04bd                	add	s1,s1,15
    1216:	8091                	srl	s1,s1,0x4
    1218:	0014899b          	addw	s3,s1,1
    121c:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
    121e:	00000517          	auipc	a0,0x0
    1222:	28a53503          	ld	a0,650(a0) # 14a8 <freep>
    1226:	c515                	beqz	a0,1252 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1228:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    122a:	4798                	lw	a4,8(a5)
    122c:	02977f63          	bgeu	a4,s1,126a <malloc+0x70>
  if(nu < 4096)
    1230:	8a4e                	mv	s4,s3
    1232:	0009871b          	sext.w	a4,s3
    1236:	6685                	lui	a3,0x1
    1238:	00d77363          	bgeu	a4,a3,123e <malloc+0x44>
    123c:	6a05                	lui	s4,0x1
    123e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1242:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1246:	00000917          	auipc	s2,0x0
    124a:	26290913          	add	s2,s2,610 # 14a8 <freep>
  if(p == (char*)-1)
    124e:	5afd                	li	s5,-1
    1250:	a895                	j	12c4 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    1252:	00000797          	auipc	a5,0x0
    1256:	2c678793          	add	a5,a5,710 # 1518 <base>
    125a:	00000717          	auipc	a4,0x0
    125e:	24f73723          	sd	a5,590(a4) # 14a8 <freep>
    1262:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1264:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1268:	b7e1                	j	1230 <malloc+0x36>
      if(p->s.size == nunits)
    126a:	02e48c63          	beq	s1,a4,12a2 <malloc+0xa8>
        p->s.size -= nunits;
    126e:	4137073b          	subw	a4,a4,s3
    1272:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1274:	02071693          	sll	a3,a4,0x20
    1278:	01c6d713          	srl	a4,a3,0x1c
    127c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    127e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1282:	00000717          	auipc	a4,0x0
    1286:	22a73323          	sd	a0,550(a4) # 14a8 <freep>
      return (void*)(p + 1);
    128a:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    128e:	70e2                	ld	ra,56(sp)
    1290:	7442                	ld	s0,48(sp)
    1292:	74a2                	ld	s1,40(sp)
    1294:	7902                	ld	s2,32(sp)
    1296:	69e2                	ld	s3,24(sp)
    1298:	6a42                	ld	s4,16(sp)
    129a:	6aa2                	ld	s5,8(sp)
    129c:	6b02                	ld	s6,0(sp)
    129e:	6121                	add	sp,sp,64
    12a0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    12a2:	6398                	ld	a4,0(a5)
    12a4:	e118                	sd	a4,0(a0)
    12a6:	bff1                	j	1282 <malloc+0x88>
  hp->s.size = nu;
    12a8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    12ac:	0541                	add	a0,a0,16
    12ae:	00000097          	auipc	ra,0x0
    12b2:	eca080e7          	jalr	-310(ra) # 1178 <free>
  return freep;
    12b6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    12ba:	d971                	beqz	a0,128e <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12bc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    12be:	4798                	lw	a4,8(a5)
    12c0:	fa9775e3          	bgeu	a4,s1,126a <malloc+0x70>
    if(p == freep)
    12c4:	00093703          	ld	a4,0(s2)
    12c8:	853e                	mv	a0,a5
    12ca:	fef719e3          	bne	a4,a5,12bc <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    12ce:	8552                	mv	a0,s4
    12d0:	00000097          	auipc	ra,0x0
    12d4:	b92080e7          	jalr	-1134(ra) # e62 <sbrk>
  if(p == (char*)-1)
    12d8:	fd5518e3          	bne	a0,s5,12a8 <malloc+0xae>
        return 0;
    12dc:	4501                	li	a0,0
    12de:	bf45                	j	128e <malloc+0x94>
